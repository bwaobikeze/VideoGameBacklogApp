//
//  GamesForPlatformView.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/24/23.
//

import SwiftUI

struct GamesForPlatformView: View {
    @State var PlatformID: Int = 0
    @State private var listOfPlatformGames = [Game]()
    @State private var selectedGame: Game?
    let Columns:[GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
        //GridItem(.flexible(), spacing: 8, alignment: nil)
    ]
    var body: some View {
        VStack{
            ScrollView(.vertical){
                LazyVGrid(columns: Columns){
                    ForEach(listOfPlatformGames, id: \.id){ Gamelist in
                        Button(action: {
                            selectedGame = Gamelist
                        }, label: {
                            VStack{
                                Rectangle().foregroundColor(.black).frame(width: 150, height: 200).cornerRadius(15).overlay {
                                    AsyncImage(url: Gamelist.background_image) { image in
                                        
                                        image.resizable()
                                            .aspectRatio(150/200,contentMode: .fit)
                                            .frame(maxWidth: 150, maxHeight: 200)
                                            .cornerRadius(15)
                                        
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                }
                                Text(Gamelist.name)
                            }

                        }).sheet(item: $selectedGame) { gameID in
                            GameContentView(gameID: gameID.id)
                        }
                    }
                }
        }
        .task {
            await loadGamesOfPlatform()
        }
    }
        
        
    }
    func loadGamesOfPlatform() async{
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&parent_platforms=\(PlatformID)&page_size=40") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
            listOfPlatformGames = decodedGameResponse.results
        } catch {
            debugPrint(error)
        }
    }
    
}

#Preview {
    GamesForPlatformView()
}
