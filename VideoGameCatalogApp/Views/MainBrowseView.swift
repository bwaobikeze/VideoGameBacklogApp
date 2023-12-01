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
    @State private var selectedGame: Game?
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State var Columns:[GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil)
    ]
    @State private var hasPerformedOnAppear = false
    
    var body: some View {
        NavigationView {
            if heightSize == .regular {
                ScrollView(.vertical) {
                    VStack {
                        (Text("Browse ").foregroundColor(color.DarkOrange) + Text("Games"))
                            .font(.custom("Poppins-SemiBold", size: 24))
                            .bold()
                            .padding(.horizontal)
                            .navigationBarItems(trailing:
                                                    NavigationLink(destination: BrowseSearchView()) {
                                Image("zoom").frame(maxWidth: .infinity, alignment: .trailing).padding()
                            }
                            )
                        /*
                         Most popular games view logic
                         */
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(popularGames, id: \.id) { popgames in
                                    Button(action: {
                                        selectedGame = popgames
                                    }) {
                                        AsyncImage(url: popgames.background_image) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 350, maxHeight: 200)
                                                .cornerRadius(15)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }.sheet(item: $selectedGame) { gameID in
                                        GameContentView(gameID: gameID.id)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        /*
                         Playstation 5 popular games view logic
                         */
                        
                        VStack(spacing: 0) {
                            Text("Playstation 5").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).bold().padding()
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Playstation5Games, id: \.id) { play5 in
                                        Button {
                                            selectedGame = play5
                                        } label: {
                                            VStack {
                                                Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                                    AsyncImage(url: play5.background_image) { image in
                                                        image.resizable()
                                                            .aspectRatio(100/100, contentMode: .fit)
                                                            .frame(maxWidth: 150, maxHeight: 150)
                                                            .cornerRadius(15)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                }
                                                Text(play5.name).font(.custom("Poppins-Regular", size: 12)).frame(width: 100).multilineTextAlignment(.center).foregroundStyle(Color.black)
                                            }
                                        }.sheet(item: $selectedGame) { gameID in
                                            GameContentView(gameID: gameID.id)
                                        }
                                    }
                                }
                            }.task {
                                await laodingThreeConsoleGames(platformID: 187, arrOfGames: &Playstation5Games)
                            }
                        }
                        /*
                         Xbox Series x popular games view logic
                         */
                        Text("Xbox Series x").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).bold().padding()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(XboxSXGames, id: \.id) { play5 in
                                    Button {
                                        selectedGame = play5
                                    } label: {
                                        VStack {
                                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                                AsyncImage(url: play5.background_image) { image in
                                                    image.resizable()
                                                        .aspectRatio(100/100, contentMode: .fit)
                                                        .frame(maxWidth: 150, maxHeight: 150)
                                                        .cornerRadius(15)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }
                                            Text(play5.name).font(.custom("Poppins-Regular", size: 12)).frame(width: 100).multilineTextAlignment(.center).foregroundStyle(Color.black)
                                        }
                                    }.sheet(item: $selectedGame) { gameID in
                                        GameContentView(gameID: gameID.id)
                                    }
                                }
                            }.task {
                                await laodingThreeConsoleGames(platformID: 186, arrOfGames: &XboxSXGames)
                            }
                        }
                        /*
                         Nintendo switch popular games view logic
                         */
                        Text("Nintendo switch").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).bold().padding()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(SwicthGames, id: \.id) { play5 in
                                    Button {
                                        selectedGame = play5
                                    } label: {
                                        VStack {
                                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                                AsyncImage(url: play5.background_image) { image in
                                                    image.resizable()
                                                        .aspectRatio(100/100, contentMode: .fit)
                                                        .frame(maxWidth: 150, maxHeight: 150)
                                                        .cornerRadius(15)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }
                                            Text(play5.name).font(.custom("Poppins-Regular", size: 12)).frame(width: 100).multilineTextAlignment(.center).foregroundStyle(Color.black)
                                        }
                                    }.sheet(item: $selectedGame) { gameID in
                                        GameContentView(gameID: gameID.id)
                                    }
                                }
                            }.task {
                                await laodingThreeConsoleGames(platformID: 7, arrOfGames: &SwicthGames)
                            }
                        }
                    }
                    /*
                     Different Platforms view logic
                     */
                    Text("See more from").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).padding()
                    LazyVGrid(columns: Columns) {
                        ForEach(GamePlatforms, id: \.id) { plat in
                            NavigationLink {
                                GamesForPlatformView(PlatformID: plat.id)
                            } label: {
                                Rectangle().foregroundColor(.black).frame(width: 150, height: 200).cornerRadius(15).overlay {
                                    ZStack {
                                        AsyncImage(url: plat.platforms[0].image_background) { image in
                                            image.resizable()
                                                .aspectRatio(150/200, contentMode: .fit)
                                                .frame(maxWidth: 150, maxHeight: 200)
                                                .cornerRadius(15).blur(radius: 4)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        Text(plat.name).font(.custom("Poppins-SemiBold", size: 20)).foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }.onAppear {
                        if hasPerformedOnAppear {
                            deletefromgridArray()
                            hasPerformedOnAppear = false
                        }
                    }
                }
                .task {
                    await loadGamePlatforms()
                    await laodingMostPopularGames()
                }
            }
            else {
                // Landscape mode code
                ScrollView(.vertical) {
                    VStack {
                        (Text("Browse ").foregroundColor(color.DarkOrange) + Text("Games"))
                            .font(.custom("Poppins-SemiBold", size: 24))
                            .bold()
                            .padding(.horizontal)
                            .navigationBarItems(trailing:
                                                    NavigationLink(destination: BrowseSearchView()) {
                                Image("zoom").frame(maxWidth: .infinity, alignment: .trailing).padding()
                            }
                            )
                        /*
                         Most popular games view logic
                         */
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(popularGames, id: \.id) { popgames in
                                    Button(action: {
                                        selectedGame = popgames
                                    }) {
                                        AsyncImage(url: popgames.background_image) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 350, maxHeight: 200)
                                                .cornerRadius(15)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }.sheet(item: $selectedGame) { gameID in
                                        GameContentView(gameID: gameID.id)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        /*
                         Playstation 5 popular games view logic(Landscape)
                         */
                        VStack(spacing: 0) {
                            Text("Playstation 5").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).bold().padding()
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Playstation5Games, id: \.id) { play5 in
                                        Button {
                                            selectedGame = play5
                                        } label: {
                                            VStack {
                                                Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                                    AsyncImage(url: play5.background_image) { image in
                                                        image.resizable()
                                                            .aspectRatio(100/100, contentMode: .fit)
                                                            .frame(maxWidth: 150, maxHeight: 150)
                                                            .cornerRadius(15)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                }
                                                Text(play5.name).font(.custom("Poppins-Regular", size: 12)).frame(width: 100).multilineTextAlignment(.center).foregroundStyle(Color.black)
                                            }
                                        }.sheet(item: $selectedGame) { gameID in
                                            GameContentView(gameID: gameID.id)
                                        }
                                    }
                                }
                            }.task {
                                await laodingThreeConsoleGames(platformID: 187, arrOfGames: &Playstation5Games)
                            }
                        }
                        /*
                         Xbox Series x popular games view logic(Landscape)
                         */
                        Text("Xbox Series x").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).bold().padding()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(XboxSXGames, id: \.id) { play5 in
                                    Button {
                                        selectedGame = play5
                                    } label: {
                                        VStack {
                                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                                AsyncImage(url: play5.background_image) { image in
                                                    image.resizable()
                                                        .aspectRatio(100/100, contentMode: .fit)
                                                        .frame(maxWidth: 150, maxHeight: 150)
                                                        .cornerRadius(15)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }
                                            Text(play5.name).font(.custom("Poppins-Regular", size: 12)).frame(width: 100).multilineTextAlignment(.center).foregroundStyle(Color.black)
                                        }
                                    }.sheet(item: $selectedGame) { gameID in
                                        GameContentView(gameID: gameID.id)
                                    }
                                }
                            }.task {
                                await laodingThreeConsoleGames(platformID: 186, arrOfGames: &XboxSXGames)
                            }
                        }
                        /*
                         Nintendo switch popular games view logic(Landscape)
                         */
                        Text("Nintendo switch").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).bold().padding()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(SwicthGames, id: \.id) { play5 in
                                    Button {
                                        selectedGame = play5
                                    } label: {
                                        VStack {
                                            Rectangle().foregroundColor(.black).frame(width: 100, height: 100).cornerRadius(15).overlay {
                                                AsyncImage(url: play5.background_image) { image in
                                                    image.resizable()
                                                        .aspectRatio(100/100, contentMode: .fit)
                                                        .frame(maxWidth: 150, maxHeight: 150)
                                                        .cornerRadius(15)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }
                                            Text(play5.name).font(.custom("Poppins-Regular", size: 12)).frame(width: 100).multilineTextAlignment(.center).foregroundStyle(Color.black)
                                        }
                                    }.sheet(item: $selectedGame) { gameID in
                                        GameContentView(gameID: gameID.id)
                                    }
                                }
                            }.task {
                                await laodingThreeConsoleGames(platformID: 7, arrOfGames: &SwicthGames)
                            }
                        }
                    }
                    /*
                     Different platforms view logic(Landscape)
                     */
                    Text("See more from").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).padding()
                    LazyVGrid(columns: Columns) {
                        ForEach(GamePlatforms, id: \.id) { plat in
                            NavigationLink {
                                GamesForPlatformView(PlatformID: plat.id)
                            } label: {
                                Rectangle().foregroundColor(.black).frame(width: 150, height: 200).cornerRadius(15).overlay {
                                    ZStack {
                                        AsyncImage(url: plat.platforms[0].image_background) { image in
                                            image.resizable()
                                                .aspectRatio(150/200, contentMode: .fit)
                                                .frame(maxWidth: 150, maxHeight: 200)
                                                .cornerRadius(15).blur(radius: 4)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        Text(plat.name).font(.custom("Poppins-SemiBold", size: 20)).foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }.onAppear {
                        if !hasPerformedOnAppear {
                            addtogridArray()
                            hasPerformedOnAppear = true
                        }
                    }
                }
                .task {
                    await loadGamePlatforms()
                    await laodingMostPopularGames()
                }
            }
        }.navigationViewStyle(.stack)
    }
    /*
     addtogridArray():
     add an grid item to the grid array
     to change the layout of the platform grid
     */
    func addtogridArray() {
        let addedgridItem: GridItem = GridItem(.flexible(), spacing: 8, alignment: nil)
        Columns.append(addedgridItem)
    }
    func deletefromgridArray() {
        Columns.removeLast()
    }
    /*
     laodingThreeConsoleGames():
     execute a api call to with the specific console id
     to get the games associated with the platform
     */
    func laodingThreeConsoleGames(platformID: Int, arrOfGames: inout [Game]) async {
        let apiKeyGame = Config.rawgApiKey
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
    /*
     laodingMostPopularGames():
     execute a api call to get the current
     most popular games for any platform
     */
    func laodingMostPopularGames() async {
        let apiKeyGame = Config.rawgApiKey
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
    /*
     loadGamePlatforms():
     execute a api call to get all of the differnt platforms
     */
    func loadGamePlatforms() async {
        let apiKeyGame = Config.rawgApiKey
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
        MainBrowseView()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

