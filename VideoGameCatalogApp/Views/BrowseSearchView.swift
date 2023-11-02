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
    var body: some View {
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
                                var mutableGame = game
                                Button(action: {
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
        }
    }
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
        }
    }

