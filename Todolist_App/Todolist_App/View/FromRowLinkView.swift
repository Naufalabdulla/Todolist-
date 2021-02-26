//
//  FromRowLinkView.swift
//  Todolist_App
//
//  Created by Naufal Faqiih Ashshiddiq on 22/02/21.
//

import SwiftUI

struct FromRowLinkView: View {
    
    var icon : String
    var color : Color
    var text : String
    var link : String
    
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }// Penutup ZStack
            .frame(width: 36, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(text)
                .foregroundColor(Color.blue)
            Spacer()
            Button(action: {
                // openLink
                guard let url = URL(string: self.link),UIApplication.shared.canOpenURL(url) else{
                    return
                }
                UIApplication.shared.open(url as URL)
            }){
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
//            .accentColor(Color(.systemGray2))
        }
    }
}

struct FromRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FromRowLinkView(icon: "globe", color: Color.pink, text: "Twitter", link: "www.twitter.com")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
