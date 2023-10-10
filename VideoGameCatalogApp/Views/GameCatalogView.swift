//
//  GameCatalogView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI

struct GameCatalogView: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack{
            Text("Game Catalog view")
            //Text(userData.userId!)
        }
    }
}

#Preview {
    GameCatalogView()
}
