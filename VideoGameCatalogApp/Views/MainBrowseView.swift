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
    @State private var Playstation5Games = [Game]()
    @State private var XboxSXGames = [Game]()
    @State private var SwicthGames = [Game]()
    let Columns:[GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil)
    ]
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
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
                Text("Playstation 5").font(.title2).frame(maxWidth: .infinity, alignment: .leading ).padding()
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(Playstation5Games, id: \.id){ play5 in
                                    VStack{
                                        Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                            
                                            AsyncImage(url: play5.background_image) { image in
                                                
                                                image.resizable()
                                                    .aspectRatio(100/100,contentMode: .fit)
                                                    .frame(maxWidth: 150, maxHeight: 150)
                                                    .cornerRadius(15)
                                                
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        Text(play5.name).multilineTextAlignment(.center)
                                    }
                                }
                                
                            }
                            .task {
                                await laodingThreeConsoleGames(platformID: 187, arrOfGames: &Playstation5Games)
                            }
                            
                        }
                    
                Text("Xbox Series x").font(.title2).frame(maxWidth: .infinity, alignment: .leading ).padding()
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(XboxSXGames, id: \.id){ play5 in
                                    VStack{
                                        Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                            
                                            AsyncImage(url: play5.background_image) { image in
                                                
                                                image.resizable()
                                                    .aspectRatio(100/100,contentMode: .fit)
                                                    .frame(maxWidth: 150, maxHeight: 150)
                                                    .cornerRadius(15)
                                                
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        Text(play5.name).multilineTextAlignment(.center)
                                    }
                                }
                                
                            }
                            .task {
                                await laodingThreeConsoleGames(platformID: 186, arrOfGames: &XboxSXGames)
                            }
                            
                        }
                   Text("Nintendo switch").font(.title2).frame(maxWidth: .infinity, alignment: .leading ).padding()
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(SwicthGames, id: \.id){ play5 in
                                    VStack{
                                        Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                            
                                            AsyncImage(url: play5.background_image) { image in
                                                
                                                image.resizable()
                                                    .aspectRatio(100/100,contentMode: .fit)
                                                    .frame(maxWidth: 150, maxHeight: 150)
                                                    .cornerRadius(15)
                                                
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        Text(play5.name).multilineTextAlignment(.center)
                                    }
                                }
                                
                            }
                            .task {
                                await laodingThreeConsoleGames(platformID: 7, arrOfGames: &SwicthGames)
                            }
                            
                        }
                Spacer()
                Text("See more from").font(.title2).frame(maxWidth: .infinity, alignment: .leading ).padding()
                LazyVGrid(columns: Columns ){
                    ForEach(GamePlatforms, id: \.id){plat in
                        NavigationLink {
                            GamesForPlatformView(PlatformID: plat.id)
                        } label: {
                            Rectangle().foregroundColor(.black).frame(width: 150, height: 200).cornerRadius(15).overlay {
                                Text(plat.name).foregroundStyle(.white)
                            }
                        }
                        
                    }
                }
                
                
                
            }.navigationTitle("Browse")
                .task {
                    await loadGamePlatforms()
                    await laodingMostPopularGames()
                }
        }
            }
            
        }
        func laodingThreeConsoleGames(platformID:Int,arrOfGames:inout[Game]) async{
            let apiKeyGame=Config.rawgApiKey
            guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&platforms=\(platformID)&page_size=10") else {
                print("Invalid URL")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedGameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
                arrOfGames = decodedGameResponse.results
            } catch {
                debugPrint(error)
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

