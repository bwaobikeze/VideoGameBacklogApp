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
    @State var gameID: Int = 0
    @State private var Gamed = GameDetailResponse(id: 0, name: "", description_raw: "")
    @State private var GamesScreenshot = [GameScreenShot]()
    var body: some View {
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
                        
                    }
                        Text(Gamed.name).font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: 271, maxHeight: 59)
                        
                    }.offset(y:-40)
                

            }
                ScrollView(.vertical){
                    Text(Gamed.description_raw).font(.custom("Poppins-Regular", size: 13)).multilineTextAlignment(.leading).padding()
                }.offset(y:-40)
                    Text("Screenshots").font(.custom("Poppins-Medium", size: 32))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading ).padding().offset(y:40)
                    
                ScrollView(.horizontal){
                    HStack{
                    ForEach(GamesScreenshot ,id: \.id){
                        GameScreenshot in
                        AsyncImage(url: GameScreenshot.image) { image in
                            image.resizable()
                                .aspectRatio(159/75,contentMode: .fit)
                                .frame(width: 159, height: 75)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                    }
                }
                }.padding()

                    
                    Button(action: {
                        addGameToCatalog(gameObj: &Gamed)
                    }) {
                        Text("Add to catalog")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(color.DarkOrange)
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                
            
        }.background(.lightGrey).ignoresSafeArea().task {
            await loadDataDetailGame()
            await loadDataDetailGameScreenshot()
        }
    }
        
    }
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

#Preview {
    GameContentView()
    
}
