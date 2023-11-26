//
//  loginLogout.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/31/23.
//

import Foundation
// Represents user settings, conforming to ObservableObject.
class UserSettings: ObservableObject{
    @Published var isLoggedin: Bool {
        didSet{
            UserDefaults.standard.set(isLoggedin, forKey: "login")
        }
    }
    // Initializes the UserSettings with a default value for isLoggedin.
    init() {
        self.isLoggedin = false
    }
}
