//
//  ContentView.swift
//  Todolist_App
//
//  Created by Naufal Faqiih Ashshiddiq on 15/02/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Todolist_App.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todolist_App.name, ascending: true)]) var todos : FetchedResults<Todolist_App>
    @EnvironmentObject var iconSetting : IconNames
    
    @State private var showingSettingView : Bool = false
    @State private var showingAddToDo : Bool = false
    @State private var animatingButton : Bool = false
    
    @ObservedObject var theme = ThemeSetting.shared
    var themes: [Theme] = themeData
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    ForEach(self.todos, id: \.self){ todo in
                        HStack{
                            Circle()
                                .frame(width: 12,height: 12, alignment: .center)
                                .foregroundColor(self.colorSize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(width: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2))
                                )
                        }// Penutup HStack
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationBarTitle("To do", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                                    trailing:
                                        Button(action: {self.showingSettingView.toggle()
                                        }){
                                            Image(systemName: "paintbrush")
                                        }
                                        .accentColor(themes[self.theme.themeSettings].themeColor)
                    .sheet(isPresented: $showingSettingView){
                        SettingView().environmentObject(self.iconSetting)
                        }
                )
                // Ketika tidak ada item
                if todos.count == 0{
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddToDo){
                AddToDo().environment(\.managedObjectContext, self.managedObjectContext)
                }
            .overlay(
                ZStack{
                    Group{
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.2:0)
                            .scaleEffect(self.animatingButton ? 1:0)
                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.15:0)
                            .scaleEffect(self.animatingButton ? 1:0)
                            .frame(width: 88, height: 88, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    } // Penutup Group
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    
                    Button(action: {
                        self.showingAddToDo.toggle()
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }// Button
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }// ZStack
                .padding(.bottom, 15)
                .padding(.trailing, 15), alignment: .bottomTrailing
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private func deleteTodo(at offsets: IndexSet){
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do{
                try managedObjectContext.save()
            }catch{
                print(error)
            }
        }
    }// Function Delete
    private func colorSize(priority: String) -> Color {
        switch priority {
        case "High":
            return.red
        case "Normal":
            return.yellow
        case "Low":
            return.green
        default:
            return.gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext,context)
    }
}
