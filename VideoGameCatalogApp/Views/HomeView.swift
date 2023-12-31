//
//  HomeView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
import FirebaseFirestore
struct HomeView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var userData: UserData
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State private var profileImageRendered: URL?
    var body: some View {
            //portrait mode UI logic
            NavigationView{
                TabView (selection: $selectedTab){
                    HomeMainView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }.toolbarBackground(.visible, for: .tabBar)
                        .tag(0)
                    MainBrowseView().accentColor(.black)
                        .tabItem {
                            Image(systemName: "gamecontroller.fill")
                            
                            Text("Browse")
                        }.toolbarBackground(.visible, for: .tabBar).tag(1)
                    MainProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }.toolbarBackground(.visible, for: .tabBar)
                        .tag(2)

                }.accentColor(selectedTab == 0 ? color.DarkOrange : selectedTab == 0 ? Color.darkOrange : (selectedTab == 1 ? Color.darkOrange : Color.darkOrange)).tabViewStyle(.automatic)
                    .onChange(of: selectedTab) { newTab in
                        selectedTab = newTab
                    }
            }.navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
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
