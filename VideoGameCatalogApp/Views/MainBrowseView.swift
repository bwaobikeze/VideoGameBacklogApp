//
//  MainBrowseView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
import ACarousel


struct MainBrowseView: View {
    @State private var GamePlatforms = [ParentPlatform]()
    @State private var popularGames = [Game]()
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: BrowseSearchView()){
                    Image("zoom").frame(maxWidth: .infinity, alignment: .trailing).padding()
                }
                ScrollView(.horizontal){
                HStack{
                    ForEach(popularGames, id: \.id){ popgames in
                        AsyncImage(url: popgames.background_image) { image in
                            
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 350, maxHeight: 200)
                                .cornerRadius(15)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                    }
                }
                    
            }
   

            Spacer()
            List{
                Section(header: Text("Playstation 5").font(.title2)) {
                    ScrollView(.horizontal){
                        HStack{
                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                
                            }
                        }
                    }
                }
                Section(header: Text("Xbox Series x").font(.title2)) {
                    ScrollView(.horizontal){
                        HStack{
                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                
                            }
                        }
                    }
                }
                Section(header: Text("Nintendo switch").font(.title2)) {
                    ScrollView(.horizontal){
                        HStack{
                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                
                            }
                        }
                    }
                }
                
            }
            .listStyle(PlainListStyle())

            Spacer()
            

        }.navigationTitle("Browse")
        .task {
            await loadGamePlatforms()
            await laodingMostPopularGames()
        }
    }

    }
    func laodingMostPopularGames() async {
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&ordering=created&page_size=10") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
            popularGames = decodedGameResponse.results
        } catch {
          debugPrint(error)
        }
    }
    func loadGamePlatforms() async {
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/platforms/lists/parents?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(PlatformResponse.self, from: data)
            GamePlatforms = decodedGameResponse.results
        } catch {
          debugPrint(error)
        }
    }

}

struct MainBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        MainBrowseView()
    }
}
