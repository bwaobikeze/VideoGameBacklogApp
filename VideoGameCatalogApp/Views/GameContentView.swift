//
//  GameContentView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI
import FirebaseFirestore

struct  GameDetailResponse:Codable, Identifiable{
    var id: Int?
    var name: String
    var background_image_additional: URL?
    var background_image: URL?
    var description_raw: String
    var userId:String?
    var GameDataBaseID:String?
    
}


struct GameContentView: View {
    @EnvironmentObject var userData: UserData
    @State var gameID: Int = 3328
    @State private var Gamed = GameDetailResponse(id: 0, name: "", description_raw: "")
    @State private var GamesScreenshot = [GameScreenShot]()
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State var getimageZoom:URL?
    @State var ShowNewImageScreen = false
    @State var isInCatlog = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
            GeometryReader { geometry in
                VStack(spacing: 10){
                    AsyncImage(url: Gamed.background_image_additional) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height / 2)
                            .edgesIgnoringSafeArea(.all)
                    } placeholder: {
                        ProgressView()
                    }
                    ZStack{
                        HStack{
                            Rectangle().foregroundColor(.black).frame(width: 96, height: 133).cornerRadius(15).overlay {
                                
                                AsyncImage(url: Gamed.background_image) { image in
                                    image.resizable()
                                        .aspectRatio(96/133,contentMode: .fit)
                                        .frame(width: 96, height: 133)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                            }.offset(y:-60)
                            Text(Gamed.name).font(.custom("Poppins-Medium", size: 15)).frame(maxWidth: 271, maxHeight: 59).bold()
                            
                        }.offset(y:-60)
                        
                        
                    }
                    ScrollView(){
                        Text(Gamed.description_raw).font(.custom("Poppins-Regular", size: 13)).multilineTextAlignment(.leading)
                        
                        Text("Screenshots").font(.custom("Poppins-Medium", size: 32))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading ).padding().offset(y:-38)
                        
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(GamesScreenshot ,id: \.id){
                                    GameScreenshot in
                                    Button(action: {
                                        getimageZoom = GameScreenshot.image
                                        ShowNewImageScreen.toggle()
                                    }, label: {
                                        AsyncImage(url: GameScreenshot.image) { image in
                                            image.resizable()
                                                .aspectRatio(159/75,contentMode: .fit)
                                                .frame(width: 159, height: 75)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                    }).sheet(isPresented: $ShowNewImageScreen) {
                                        ZoomedINImage(imageZoomed: getimageZoom)
                                    }
                                    
                                }
                            }
                        }.offset(y:-70)
                        .padding()
                    
                    
                    
                    Button(action: {
                        addGameToCatalog(gameObj: &Gamed)
                        Task{
                            await checkIfGameIsAlreadyInCatalog()
                        }
                    }) {
                        Text(isInCatlog ? " in catalog ✅ ": "Add to catalog")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isInCatlog ? Color.gray: color.DarkOrange)
                            .cornerRadius(30)
                    }
                    .padding()
                    .offset(y:-80)
                    .disabled(isInCatlog)
                    Spacer()
                    }
                    //.ignoresSafeArea()
                    .offset(y:-120).frame(height:400)
                    
                }.background(.lightGrey).ignoresSafeArea().task {
                    await loadDataDetailGame()
                    await loadDataDetailGameScreenshot()
                }
            }.onAppear(perform: {
                Task{
                    await checkIfGameIsAlreadyInCatalog()
                }
            })
        }else{
            ZStack{
                HStack{
                    // landscape mode UI logic
                    GeometryReader { geometry in
                        AsyncImage(url: Gamed.background_image) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: geometry.size.height+25)
                                .edgesIgnoringSafeArea(.all)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    VStack(spacing: 10){
                        ScrollView(.vertical){
                            Text(Gamed.name).font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: 271, maxHeight: 59)
                            Text(Gamed.description_raw).font(.custom("Poppins-Regular", size: 13)).multilineTextAlignment(.leading)
                            
                            Text("Screenshots").font(.custom("Poppins-Medium", size: 32))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading ).padding()
                            
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(GamesScreenshot ,id: \.id){
                                        GameScreenshot in
                                        Button(action: {
                                            getimageZoom = GameScreenshot.image
                                            ShowNewImageScreen.toggle()
                                        }, label: {
                                            AsyncImage(url: GameScreenshot.image) { image in
                                                image.resizable()
                                                    .aspectRatio(159/75,contentMode: .fit)
                                                    .frame(width: 159, height: 75)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                        }).sheet(isPresented: $ShowNewImageScreen) {
                                            ZoomedINImage(imageZoomed: getimageZoom)
                                        }
                                        
                                        
                                    }
                                }
                                
                            }
                            
                            
                            Button(action: {
                                addGameToCatalog(gameObj: &Gamed)
                                Task{
                                    await checkIfGameIsAlreadyInCatalog()
                                }
                            }) {
                                Text(isInCatlog ? " in catalog ✅ ": "Add to catalog")
                                    .font(.custom("Poppins-Medium", size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isInCatlog ? Color.gray: color.DarkOrange)
                                    .cornerRadius(30)
                            }
                            .padding()
                            .disabled(isInCatlog)
                            Spacer()
                        }.padding()
                        
                        
                    }.background(.lightGrey).ignoresSafeArea().task {
                        await loadDataDetailGame()
                        await loadDataDetailGameScreenshot()
                    }
                }.onAppear(perform: {
                    Task{
                        await checkIfGameIsAlreadyInCatalog()
                    }
                })
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(color.DarkOrange)
                        .frame(width: 50, height: 100)
                }).offset(x: -360, y: -150)
            }
            
            
        }
    }
    /*
     checkIfGameIsAlreadyInCatalog():
     Checks if a game is already in the user's catalog in Firestore.
     */
    func checkIfGameIsAlreadyInCatalog() async {
        let db = Firestore.firestore()
        let userId = userData.userId
        let gameId = gameID
        
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
     Adds a game to the user's catalog in Firestore, updating the database with the document ID.
     */
    func addGameToCatalog(gameObj: inout GameDetailResponse){
        let db = Firestore.firestore()
        gameObj.userId = userData.userId
        var ref: DocumentReference? = nil
        let data: [String: Any] = [
            "id": gameObj.id ?? "id Value",
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
     loadDataDetailGameScreenshot():
     Loads screenshots for a specific game from the RAWG API.
     */
    func loadDataDetailGameScreenshot() async {
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games/\(gameID)/screenshots?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode( GameScreenShotResponse.self, from: data)
            GamesScreenshot = decodedGameResponse.results
        } catch {
            debugPrint(error)
        }
    }
    /*
     loadDataDetailGame():
     Loads detailed information about a specific game from the RAWG API.
     */
    func loadDataDetailGame() async {
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games/\(gameID)?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(GameDetailResponse.self, from: data)
            Gamed = decodedGameResponse
        } catch {
            debugPrint(error)
        }
    }
}

struct  GameContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameContentView()
        GameContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

