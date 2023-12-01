//
//  BrowseSearchView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
import FirebaseFirestore

struct BrowseSearchView: View {
    @State private var SearchStrting:String = ""
    @State private var Games = [Game]()
    @State private var timer: Timer?
    @State private var selectedGame: Game?
    @EnvironmentObject var userData: UserData
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State var isInCatlog = false
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
            NavigationView{
                VStack {
                    Spacer()
                    Spacer()
                    TextField("Search Game", text: $SearchStrting)
                        .font(.custom("Poppins-Medium", size: 15))
                        .padding()
                        .background(color.DarkOrange)
                        .foregroundColor(.white)
                        .frame(height: 3)
                    ZStack{
                        Image("game-controller-svgrepo-com").shadow(radius: 10)
                        List(Games) { game in
                            Button(action: {
                                selectedGame = game
                            }) {
                                VStack {
                                    HStack {
                                        AsyncImage(url: game.background_image) { image in
                                            image.resizable()
                                                .aspectRatio(67/91,contentMode: .fit)
                                                .frame(maxWidth: 67, maxHeight: 91)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        VStack(spacing: 0) {
                                            Text("\(game.name)").font(.custom("Poppins-Medium", size: 16)).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.black)
                                            Text("Platforms: \(game.platforms.prefix(3).map { $0.platform.name }.joined(separator: ", "))")
                                                .font(.custom("Poppins-Medium", size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .foregroundColor(.black)
                                        }
//                                        var mutableGame = game
//                                        Button(action: {
//                                            addGameToCatalog(gameObj: &mutableGame)
//                                            Task{
//                                                await checkIfGameIsAlreadyInCatalog(selectGameid: mutableGame.id)
//                                            }
//                                        }, label: {
//                                            Text(isInCatlog ? "✅":"Add")
//                                                .font(.headline)
//                                                .foregroundColor(.black)
//                                                .padding()
//                                                .frame(maxWidth: 100,maxHeight: 30)
//                                                .background(Color.gray)
//                                                .cornerRadius(10)
//                                        })
//                                        .disabled(isInCatlog)
                                        
                                    }
                                }
                            }
                            .sheet(item: $selectedGame) { game in
                                GameContentView(gameID: game.id)
                            }
                        }.listStyle(PlainListStyle())
                    }
                    
                    .task {
                        if !SearchStrting.isEmpty {
                            await loadDataGame(SeachQ: SearchStrting)
                        } else {
                            Games = []
                        }
                    }
                }
                .onChange(of: SearchStrting) { newSearchString in
                    timer?.invalidate()
                    if newSearchString.isEmpty {
                        Games = []
                    } else {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            Task {
                                await loadDataGame(SeachQ: SearchStrting)
                            }
                        }
                    }
                }
            }.accentColor(.black)
            .navigationViewStyle(.stack)
        }else{
            // landscape mode UI logic
            NavigationView{
                VStack {
                    Spacer()
                    Spacer()
                    TextField("Search Game", text: $SearchStrting)
                        .font(.custom("Poppins-Medium", size: 15))
                        .padding()
                        .background(color.DarkOrange)
                        .foregroundColor(.white)
                        .frame(height: 3)
                    ZStack{
                        Image("game-controller-svgrepo-com").shadow(radius: 10)
                        List(Games) { game in
                            Button(action: {
                                selectedGame = game
                            }) {
                                VStack {
                                    HStack {
                                        AsyncImage(url: game.background_image) { image in
                                            image.resizable()
                                                .aspectRatio(67/91,contentMode: .fit)
                                                .frame(maxWidth: 67, maxHeight: 91)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        VStack(spacing: 0) {
                                            Text("\(game.name)").font(.custom("Poppins-Medium", size: 16)).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.black)
                                            Text("Platforms: \(game.platforms.prefix(3).map { $0.platform.name }.joined(separator: ", "))")
                                                .font(.custom("Poppins-Medium", size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .foregroundColor(.black)
                                        }
//                                        var mutableGame = game
//                                        Button(action: {
//                                            addGameToCatalog(gameObj: &mutableGame)
//                                            Task{
//                                                await checkIfGameIsAlreadyInCatalog(selectGameid: mutableGame.id)
//                                            }
//                                        }, label: {
//                                            Text(isInCatlog ? "✅":"Add")
//                                                .font(.headline)
//                                                .foregroundColor(.black)
//                                                .padding()
//                                                .frame(maxWidth: 100,maxHeight: 30)
//                                                .background(Color.gray)
//                                                .cornerRadius(10)
//                                        })
//                                        .disabled(isInCatlog)
                                    }
                                }
                            }
                            .sheet(item: $selectedGame) { game in
                                GameContentView(gameID: game.id)
                            }
                        }.listStyle(PlainListStyle())
                    }
                    
                    .task {
                        if !SearchStrting.isEmpty {
                            await loadDataGame(SeachQ: SearchStrting)
                        } else {
                            Games = []
                        }
                    }
                }
                .onChange(of: SearchStrting) { newSearchString in
                    timer?.invalidate()
                    if newSearchString.isEmpty {
                        Games = []
                    } else {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            Task {
                                await loadDataGame(SeachQ: SearchStrting)
                            }
                        }
                    }
                }
            }.navigationViewStyle(.stack)
        }
    }
    /*
     checkIfGameIsAlreadyInCatalog():
     Checks if a game with the specified ID
     is already in the user's catalog.
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
     loadDataGame():
     Loads games based on the provided search query.
     */
    func loadDataGame(SeachQ:String) async {
        
        let apiKeyGame = Config.rawgApiKey
        guard let encodedSearchQuery = SeachQ.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.rawg.io/api/games?search=\(encodedSearchQuery)&key=\(apiKeyGame)&page_size=20") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
            Games = decodedGameResponse.results
        } catch {
            debugPrint(error)
        }
    }
    /*
     addGameToCatalog():
     Adds a game to the user's catalog.
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
}

struct BrowseSearchView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseSearchView()
            .environmentObject(UserData())
        BrowseSearchView()
            .environmentObject(UserData())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

