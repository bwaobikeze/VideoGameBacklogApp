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
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State var isInCatlog = false
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
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
                                Task{
                                    await checkIfGameIsAlreadyInCatalog(selectGameid: mutableGame.id)
                                }
                            }, label: {
                                Text("Add")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: 100,maxHeight: 30)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }).onAppear(perform: {
                                Task{
                                    await checkIfGameIsAlreadyInCatalog(selectGameid: game.id)
                                }
                            })
                            .disabled(isInCatlog)
                            
                        }
                    })
                    .sheet(item: $selectedGame) { game in
                        GameContentView(gameID: game.id)
                    }
                    
                }.listStyle(PlainListStyle())
                
            }.task {
                await loadGamesOfPlatform(platnum: platformNameID)
            }
        }else{
            // landscape mode UI logic
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
                            Task{
                                await checkIfGameIsAlreadyInCatalog(selectGameid: mutableGame.id)
                            }
                        }, label: {
                            Text("Add")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: 100,maxHeight: 30)
                                .background(Color.gray)
                                .cornerRadius(10)
                        })
                        .onAppear(perform: {
                            Task{
                                await checkIfGameIsAlreadyInCatalog(selectGameid: game.id)
                            }
                        })
                        .disabled(isInCatlog)
                        
                    }
                }).sheet(item: $selectedGame) { game in
                    GameContentView(gameID: game.id)
                }
                
            }.task {
                await loadGamesOfPlatform(platnum: platformNameID)
            }
            .listStyle(PlainListStyle())
            
            
        }
        
    }
    /*
     checkIfGameIsAlreadyInCatalog():
     logic to check if the game is already in
     the users catalog
     */
    func checkIfGameIsAlreadyInCatalog(selectGameid: Int) async {
        let db = Firestore.firestore()
        let userId = userData.userId
        let gameId = selectGameid
        
        do {
            let querySnapshot = try await db.collection("VideoGames")
                .whereField("userId", isEqualTo: userId)
                .whereField("id", isEqualTo: gameId)
                .getDocuments()
            
            if !querySnapshot.isEmpty {
                // The game is already in the catalog
                print("Game already in catalog")
                isInCatlog = true
            } else {
                // The game is not in the catalog
                print("Game not in catalog")
                isInCatlog = false
            }
        } catch {
            print("Error checking game in catalog: \(error.localizedDescription)")
        }
    }
    /*
     addGameToCatalog():
     logic to add the game to the users game catalog
     in the firestore database
     */
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
    /*
     loadGamesOfPlatform():
     logic to get the platforms from the
     api
     */
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

struct RecommendedView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedView()
        RecommendedView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
