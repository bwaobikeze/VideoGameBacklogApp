//
//  VideoGameCatalogAppApp.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI
import Firebase
@main
struct VideoGameCatalogAppApp: App {
    @StateObject var userData = UserData()
    @StateObject var loginDeter = UserSettings()
    init(){
        FirebaseApp.configure()
        print("Configured FireBase!")
    }
    var body: some Scene {
        WindowGroup {
            splashScreen()
                .environmentObject(loginDeter)
                .environmentObject(userData)
        }
    }
}
