//
//  GameContentView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/10/23.
//

import SwiftUI
struct  GameDetailResponse:Codable{
    var id: Int?
    var name: String
    var background_image: URL?
    var description: String

}

struct GameContentView: View {
    @State var gameID: Int = 0
    @State private var Gamed = GameDetailResponse(id: 0, name: "", description: "")
    var body: some View {
        VStack{
            Text("Game content view")
            Text("GameID:\(gameID)")
                AsyncImage(url: Gamed.background_image) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight:200)
                } placeholder: {
                    ProgressView()
                }
            Text(Gamed.name).font(.title2)
            Text(Gamed.description).multilineTextAlignment(.leading).padding()
            
        }.task {
            await loadDataDetailGame()
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
