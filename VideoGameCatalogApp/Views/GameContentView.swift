//
//  GameContentView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI
import FirebaseFirestore

struct  GameDetailResponse:Codable{
    var id: Int?
    var name: String
    var background_image_additional: URL?
    var description_raw: String
    var userId:String?

}

struct GameContentView: View {
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
    func addGameToCatalog(){
        let db = Firestore.firestore()
        
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
