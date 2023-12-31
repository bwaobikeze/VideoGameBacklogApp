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
    @State var Columns:[GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
    ]
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
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
        }else{
            // landscape mode UI logic
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
            }.onAppear {
                addtogridArray()
            }
        }
        
        
        
    }
    /*
     addtogridArray():
     Adds a flexible grid item to the grid columns array.
     */
    func addtogridArray(){
        let addedgridItem: GridItem = GridItem(.flexible(), spacing: 8, alignment: nil)
        Columns.append(addedgridItem)
    }
    /*
     loadGamesOfPlatform():
     Loads games of a specified platform asynchronously.
     */
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
struct  GamesForPlatformView_Previews: PreviewProvider {
    static var previews: some View {
        GamesForPlatformView()
        GamesForPlatformView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

