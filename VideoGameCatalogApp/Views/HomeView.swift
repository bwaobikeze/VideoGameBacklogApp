//
//  HomeView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
struct HomeView: View {
    @State private var selectedTab = 0
    var body: some View {
        
        NavigationView{
            TabView {
                HomeMainView()
                    .tabItem {
                        Image("game-console-svgrepo-com")
                        Text("Home")
                    }.toolbarBackground(color.DarkOrange, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                    .tag(0)
                MainBrowseView()
                    .tabItem {
                        Image("game-console-svgrepo-com (1)")
                        
                        Text("Browse")
                    }.toolbarBackground(color.DarkOrange, for: .tabBar).toolbarBackground(.visible, for: .tabBar).tag(1)
                MainProfileView()
                    .tabItem {
                        Image("profile-user-avatar-man-person-svgrepo-com")
                        Text("Profile")
                    }.toolbarBackground(color.DarkOrange, for: .tabBar).toolbarBackground(.visible, for: .tabBar).tag(2)
            }.accentColor(selectedTab == 0 ? .black : .black).tabViewStyle(.automatic)
        }.navigationBarBackButtonHidden(true)
        
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserData())
    }
}
