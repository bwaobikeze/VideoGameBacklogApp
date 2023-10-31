//
//   ContentView.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/31/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        if settings.isLoggedin {
            return AnyView(HomeView())
        }else{
            return AnyView(LoginView())
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
}
