//
//  RecommendedView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI

struct RecommendedView: View {
    @EnvironmentObject var userData: UserData
    @State private var games: [GameDetailResponse] = []
    var body: some View {
        VStack{
            List(games, id: \.name) { game in
                HStack{
                    AsyncImage(url: game.background_image) { image in
                        image.resizable()
                            .aspectRatio(67/91,contentMode: .fit)
                            .frame(maxWidth: 67, maxHeight:91)
                    } placeholder: {
                        ProgressView()
                    }
                    VStack{
                        Text(game.name).font(.title2)
                    }
                }
            }.listStyle(PlainListStyle())

        }.onAppear(perform: {
            fetchGamesForUserID(userID: userData.userId ?? "not id")
        })

    }
    func fetchGamesForUserID(userID:String){
        
    }
}

#Preview {
    RecommendedView()
        .environmentObject(UserData())
}
