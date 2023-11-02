//
//  RecommendedView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI
import FirebaseFirestore

struct RecommendedView: View {
    @EnvironmentObject var userData: UserData
    @State private var games: [Game] = []
    @State var platformNameID = 0
    @State private var selectedGame: Game?
    var body: some View {
        VStack{
            List(games, id: \.name) { game in
                Button(action: {
                    selectedGame = game
                }, label: {
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
                        Spacer()
                        Button(action: {
                            var mutableGame = game
                            addGameToCatalog(gameObj: &mutableGame)
                        }, label: {
                            Text("Add")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: 100,maxHeight: 30)
                                .background(Color.gray)
                                .cornerRadius(10)
                        })

                    }
                }).sheet(item: $selectedGame) { game in
                    GameContentView(gameID: game.id)
                }

            }.listStyle(PlainListStyle())

        }.task {
                await loadGamesOfPlatform(platnum: platformNameID)
        }

    }
    func addGameToCatalog(gameObj: inout Game){
        let db = Firestore.firestore()
        gameObj.userId = userData.userId
        var ref: DocumentReference? = nil
        let data: [String: Any] = [
            "id": gameObj.id ,
            "userId": gameObj.userId ?? "not user ID"
        ]

        ref = db.collection("VideoGames").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                // Document added successfully, now update the "gameId" field with the document ID
                if let documentId = ref?.documentID {
                    db.collection("VideoGames").document(documentId).updateData(["GameDBID": documentId]) { updateError in
                        if let updateError = updateError {
                            print("Error updating gameId field: \(updateError)")
                        } else {
                            print("Document added with ID and gameId set: \(documentId)")
                        }
                    }
                }
            }
        }

        
    }

    func loadGamesOfPlatform(platnum: Int) async{
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&platforms=\(platnum)&page_size=20&ordering=-released") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
            games = decodedGameResponse.results
        } catch {
            debugPrint(error)
        }
    }
}

#Preview {
    RecommendedView()
        .environmentObject(UserData())
}
