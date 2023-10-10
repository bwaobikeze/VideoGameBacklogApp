//
//  HomeView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            TabView {
                HomeMainView()
                    .tabItem {
                        Image("game-console-svgrepo-com")
                        Text("Home")
                    }
                MainBrowseView()
                    .tabItem {
                        Image("game-console-svgrepo-com (1)")
                        Text("Browse")
                    }
                MainProfileView()
                    .tabItem {
                        Image("profile-user-avatar-man-person-svgrepo-com")
                        Text("Profile")
                    }
            }
        }.navigationBarBackButtonHidden(true)
        
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
