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
    var body: some View {
        VStack{
            List(games, id: \.name) { game in
                HStack{
                    AsyncImage(url: game.background_image) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight:200)
                    } placeholder: {
                        ProgressView()
                    }
                    VStack{
                        Text(game.name).font(.title2)
                    }
                }
                }

        }.onAppear(perform: {
            fetchGamesForUserID(userID: userData.userId ?? "not id")
        })
    }
    func fetchGamesForUserID(userID: String) {
        db.collection("VideoGames")
              .whereField("userId", isEqualTo: userID)
              .getDocuments { (querySnapshot, error) in
                  if let error = error {
                      print("Error fetching documents: \(error)")
                  } else {
                      for document in querySnapshot!.documents {
                          if let gameID = document.data()["id"] as? Int {
                              // Pass the game ID to a different function
                              print(gameID)
                              Task{
                                  await  processGame(gameID)
                              }
                          }
                      }
                  }
              }
    }
    func processGame (_ gameID: Int) async {
           // You can implement your logic here to process the game
           // For example, you can fetch additional data or perform other actions
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games/\(gameID)?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(GameDetailResponse.self, from: data)
            games.append(decodedGameResponse)
        } catch {
          debugPrint(error)
        }
       }
    
}

#Preview {
    GameCatalogView()
        .environmentObject(UserData())
}
