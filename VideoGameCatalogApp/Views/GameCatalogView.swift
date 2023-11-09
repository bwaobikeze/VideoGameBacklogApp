//
//  GameCatalogView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI
import FirebaseFirestore

struct GameCatalogView: View {
    @EnvironmentObject var userData: UserData
    @State private var games: [GameDetailResponse] = []
    let db = Firestore.firestore()
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
        @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    var body: some View {
        if heightSize == .regular{
            VStack{
                List{
                    ForEach(games, id: \.name){game in
                        HStack{
                            AsyncImage(url: game.background_image) { image in
                                image.resizable()
                                    .aspectRatio(67/91,contentMode: .fit)
                                    .frame(maxWidth: 67, maxHeight:91)
                            } placeholder: {
                                ProgressView()
                            }
                            VStack{
                                Text(game.name).font(.title2).font(.custom("Poppins-Medium", size: 16))
                            }
                        }
                    }
                    .onDelete(perform: deleteGame)

                }
                .listStyle(PlainListStyle())

            }.onAppear(perform: {
                fetchGamesForUserID(userID: userData.userId ?? "not id")
            })
        }else{
            VStack{
                List{
                    ForEach(games, id: \.name){game in
                        HStack{
                            AsyncImage(url: game.background_image) { image in
                                image.resizable()
                                    .aspectRatio(67/91,contentMode: .fit)
                                    .frame(maxWidth: 67, maxHeight:91)
                            } placeholder: {
                                ProgressView()
                            }
                            VStack{
                                Text(game.name).font(.title2).font(.custom("Poppins-Medium", size: 16))
                            }
                        }
                    }
                    .onDelete(perform: deleteGame)

                }
                .listStyle(PlainListStyle())

            }.onAppear(perform: {
                //fetchGamesForUserID(userID: userData.userId ?? "not id")
            })
        }
    }
    func fetchGamesForUserID(userID: String) {
        db.collection("VideoGames")
            .whereField("userId", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let gameID = document.data()["id"] as? Int,
                           let gameDBID = document.data()["GameDBID"] as? String {
                            // Pass the game ID and GameDBID to a different function
                            print("Game ID: \(gameID)")
                            print("GameDBID: \(gameDBID)")
                            Task {
                                await processGame(gameID, gameDBID)
                            }
                        }
                    }
                }
            }
        }
    func deleteGame(at offsets: IndexSet) {
        for offset in offsets {
            let game = games[offset]
            if let gamedataBaseID = game.GameDataBaseID { // Assuming you have the GamedataBaseID stored in the GameDetailResponse
                // Call your DeleteItem function to delete the item from the database
                DeleteItem(at: gamedataBaseID)
            }
        }
    }
    
    func DeleteItem(at GamedataBaseID: String){
        db.collection("VideoGames").document(GamedataBaseID).delete(){err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    func processGame (_ gameID: Int, _ gameDID: String) async {
           // You can implement your logic here to process the game
           // For example, you can fetch additional data or perform other actions
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games/\(gameID)?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            var decodedGameResponse = try JSONDecoder().decode(GameDetailResponse.self, from: data)
            decodedGameResponse.GameDataBaseID = gameDID
            games.append(decodedGameResponse)
        } catch {
          debugPrint(error)
        }
       }
    
}

struct  GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView()
            .environmentObject(UserData())
            .previewInterfaceOrientation(.landscapeLeft)
        GameCatalogView()
            .environmentObject(UserData())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
