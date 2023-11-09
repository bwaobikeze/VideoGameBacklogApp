//
//  HomeView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
struct HomeView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var settings: UserSettings
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
        @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    var body: some View {
        if heightSize == .regular{
            NavigationView{
                TabView {
                    HomeMainView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }.toolbarBackground(.visible, for: .tabBar)
                        .tag(0)
                    MainBrowseView()
                        .tabItem {
                            Image(systemName: "gamecontroller.fill")
                            
                            Text("Browse")
                        }.toolbarBackground(.visible, for: .tabBar).tag(1)
                    MainProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }.toolbarBackground(.visible, for: .tabBar).tag(2)
                }.accentColor(selectedTab == 0 ? color.DarkOrange : .black).tabViewStyle(.automatic)
            }.navigationBarBackButtonHidden(true)
        }else{
            NavigationView{
                TabView {
                    HomeMainView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }.toolbarBackground(.visible, for: .tabBar)
                        .tag(0)
                    MainBrowseView()
                        .tabItem {
                            Image(systemName: "gamecontroller.fill")
                            
                            Text("Browse")
                        }.toolbarBackground(.visible, for: .tabBar).tag(1)
                    MainProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }.toolbarBackground(.visible, for: .tabBar).tag(2)
                }.accentColor(selectedTab == 0 ? color.DarkOrange : .black).tabViewStyle(.automatic)
            }.navigationBarBackButtonHidden(true)
        }

        
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserData())
            .environmentObject(UserSettings())
        HomeView()
            .environmentObject(UserData())
            .environmentObject(UserSettings())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
