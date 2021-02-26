//
//  ThemeSetting.swift
//  Todolist_App
//
//  Created by Naufal Faqiih Ashshiddiq on 24/02/21.
//

import SwiftUI

class ThemeSetting: ObservableObject {
    @Published var themeSettings : Int = UserDefaults.standard.integer(forKey: "Theme"){
        didSet{
            UserDefaults.standard.setValue(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSetting()
    
}
