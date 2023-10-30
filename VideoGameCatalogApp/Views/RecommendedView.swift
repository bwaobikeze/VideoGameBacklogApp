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
    @State var platformChoiceID = 0
    var body: some View {
        VStack{
            List(games, id: \.name) { game in
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
                }
            }.listStyle(PlainListStyle())

        }.onAppear(perform: {
            fetchGamesForUserID()
        })

    }
    
    func fetchGamesForUserID(){
        //userData.userId ?? "not id"
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userId ?? "not id")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    // Document data is available in the "data" dictionary
                    if let PlatformNum = data["platform"] as? Int{
                        self.platformChoiceID = PlatformNum
                    }
                    
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
}

#Preview {
    RecommendedView()
        .environmentObject(UserData())
}
