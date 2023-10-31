//
//  loginLogout.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/31/23.
//

import Foundation
class UserSettings: ObservableObject{
    @Published var isLoggedin: Bool {
        didSet{
            UserDefaults.standard.set(isLoggedin, forKey: "login")
        }
    }
    init() {
        self.isLoggedin = false
    }
}
