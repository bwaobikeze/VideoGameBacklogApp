//
//  splashScreen.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 11/8/23.
//

import SwiftUI

struct splashScreen: View {
    @EnvironmentObject var settings: UserSettings
    @State private var isActive = false
    var body: some View {
        if isActive{
            ContentView()
        }else{
            ZStack{
                Image("sam-pak-X6QffKLwyoQ-unsplash").resizable().scaledToFill()
                    .ignoresSafeArea().blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                VStack{
                    Image("playstation-4-game-controllers-video-game-dualshock-joystick-7d6b0eb7e10322d99b41504a05478bcc").resizable().frame(width: 105, height: 65)
                    (Text("Saved").foregroundStyle(color.DarkOrange) + Text("Games")).font(.custom("SpaceMission", size: 32)).frame(width: .infinity)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    splashScreen()
}
