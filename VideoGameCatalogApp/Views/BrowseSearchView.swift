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
                    .padding()
                    .background(Color.orange)
                    .frame(height: 3)
                
                ScrollView(.vertical) {
                    ForEach(Games) { game in
                        Button(action: {
                            selectedGame = game
                        }) {
                            VStack {
                                HStack {
                                    AsyncImage(url: game.background_image) { image in
                                        image.resizable()
                                            .aspectRatio(150/200,contentMode: .fit)
                                            .frame(maxWidth: 150, maxHeight: 200)
                                            .cornerRadius(15)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    VStack(spacing: 0) {
                                        Text("Name: \(game.name)").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.black)
                                        Text("Released: \(game.released)").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.black)
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
                    }
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
        gameObj.userId=userData.userId
        var ref:DocumentReference? = nil
        ref=db.collection("VideoGames").addDocument(data: ["id":gameObj.id ,"userId":gameObj.userId ?? "not user ID"]){
            err in
            if let err = err{
                print("Error adding document: \(err)")
            }else{
                print("Document added with ID: \(ref!.documentID)")
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

