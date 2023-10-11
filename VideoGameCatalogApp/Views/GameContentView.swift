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

}

struct GameContentView: View {
    @EnvironmentObject var userData: UserData
    @State var gameID: Int = 0
    @State private var Gamed = GameDetailResponse(id: 0, name: "", description_raw: "")
    var body: some View {
        VStack{
            Text("Game content view")
            Text("GameID:\(gameID)")
                AsyncImage(url: Gamed.background_image_additional) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight:200)
                } placeholder: {
                    ProgressView()
                }
            Text(Gamed.name).font(.title2)
            Text(Gamed.description_raw).multilineTextAlignment(.leading).padding()

            
        }.task {
            await loadDataDetailGame()
        }
        Button(action: {
            // Handle login action here
            //Signin()
            addGameToCatalog(gameObj: &Gamed)
        }) {
            Text("Add to catalog")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(10)
        }
        .padding()
        
    }
    func addGameToCatalog(gameObj: inout GameDetailResponse){
        let db = Firestore.firestore()
        gameObj.userId=userData.userId
        var ref:DocumentReference? = nil
        ref=db.collection("VideoGames").addDocument(data: ["id":gameObj.id ?? "id Value","userId":gameObj.userId ?? "not user ID"]){
            err in
            if let err = err{
                print("Error adding document: \(err)")
            }else{
                print("Document added with ID: \(ref!.documentID)")
            }
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
