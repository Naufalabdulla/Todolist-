//
//  SettingView.swift
//  Todolist_App
//
//  Created by Naufal Faqiih Ashshiddiq on 22/02/21.
//

import SwiftUI

struct SettingView: View {
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var iconSetting : IconNames
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSetting.shared
    @State private var isThemeChanged : Bool = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0){
                
                Form{
                    
                    Section(header: Text("Choose the app icons")){
                        Picker(selection: $iconSetting.currentIndex, label: Text("App Icons")){
                            ForEach(0..<iconSetting.iconNames.count){ index in
                                HStack{
                                    Image(uiImage: UIImage(named: self.iconSetting.iconNames[index] ?? "Blue") ?? UIImage())
                                        .resizable()
                                        .renderingMode(.original)
                                        .scaledToFit()
                                        .frame(width: 44, height:44)
                                        .cornerRadius(8)
                                    Spacer().frame(width: 8)
                                    
                                    Text(self.iconSetting.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }// Penutup HStack
                                .padding(3)
                            }
                        }// Penutup Picker
                        .onReceive([self.iconSetting.currentIndex].publisher.first()){
                            (value) in
                            let index = self.iconSetting.iconNames.firstIndex(of: UIApplication.shared.alternateIconName)
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSetting.iconNames[value]){ error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }else{
                                        print("App icons has been changed")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 3)
                    
                    Section(header:
                                HStack{
                                    Text("Choose App Theme")
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(themes[self.theme.themeSettings].themeColor)
                                }
                        )// Header
                    {
                        List{
                            ForEach(themes, id: \.id){ item in
                                Button(action: {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    self.isThemeChanged.toggle()
                                }){
                                    HStack{
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        
                                        Text(item.themeName)
                                    }
                                }// Penutup image Button
                                .accentColor(Color.primary)
                            }
                        }
                    }// Penutup Section
                    .padding(.vertical, 3)
                    .alert(isPresented: $isThemeChanged){
                        Alert(
                            title: Text("Success"),
                            message: Text("Application has been changed \(themes[self.theme.themeSettings].themeName)!"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Section(header: Text("Follow us on Social Media")){
                        FromRowLinkView(icon: "globe", color: Color.pink, text: "Twitter", link: "https://www.twitter.com/")
                        FromRowLinkView(icon: "envelope", color: Color.blue, text: "Email", link: "https://mail.google.com/")
                        FromRowLinkView(icon: "link", color: Color.green, text: "Website", link: "https://www.yandex.com/")
                    }// Penutup Link
                    .padding(.vertical, 3)
                    
                    Section(header: Text("About Application")){
                        FromRowStaticView(icon: "gear", firstText: "General", secondText: "Todo")
                        FromRowStaticView(icon: "checkmark.seal", firstText: "Compability", secondText: "iPhone/iPad")
                        FromRowStaticView(icon: "keyboard", firstText: "Keyboard", secondText: "Default")
                        FromRowStaticView(icon: "paintbrush", firstText: "Aplication", secondText: "Todo")
                        FromRowStaticView(icon: "flag", firstText: "Version", secondText: "1.1.0")
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                Text("Copyright All 2021")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            }// Penutup VStack
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark")
            }
            )
        
        .navigationBarTitle("Setting", displayMode: .inline)
        .background(Color("ColorBackground"))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(IconNames())
    }
}
