import SwiftUI

struct NewsResponse: Codable {
    var status: String
    var totalResults: Int?
    var articles: [newsArticle]
}

struct GameResponse: Codable {
    var count: Int?
    var next: URL?
    var previous: URL?
    var results: [Game]
}

struct HomeMainView: View {
    @State private var articlas = [newsArticle]()
    @State private var Games = [Game]()
    @EnvironmentObject var userData: UserData
    @State private var showContentScreen: Bool = false
    @State private var selectedGame: Game?
    
    var body: some View {
        VStack {
            Text("Home").font(.title)
            Text("Upcoming In: \(getCurrentMonth()) ").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Games, id: \.slug) { game in
                        Button(action: {
                            selectedGame = game
                        }, label: {
                            VStack(spacing: 0) {
                                AsyncImage(url: game.background_image) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 300, maxHeight: 200)
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(game.name)
                            }
                            .padding() // Add some spacing between items if needed
                        }).sheet(item: $selectedGame) { gameID in
                            GameContentView(gameID: gameID.id)
                        }
                        Spacer()
                    }
                }
            }
            
            Text("Number in Catalog: ").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding()
            Text("Gaming News: ").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding()
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(articlas, id: \.title) { articla in
                        Button(action: {
                            UIApplication.shared.open(articla.url)
                        }) {
                            AsyncImage(url: articla.urlToImage) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 200, maxHeight: 200)
                            } placeholder: {
                                ProgressView()
                            }
                            Spacer()
                            Text(articla.title).frame(maxWidth: 150, maxHeight: 150)
                        }
                    }
                }
                .task {
                    await loadData()
                    await loadDataGame()
                }
            }
        }
    }

    func loadData() async {
        let apiKeyNews = Config.newsApiKey
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=IGN&q=gaming&apiKey=\(apiKeyNews)") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            articlas = decodedResponse.articles
        } catch {
            print("Error trying to decode JSON object: \(error.localizedDescription)")
        }
    }

    func loadDataGame() async {
        let apiKeyGame = Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&platforms=187&page_size=20") else {
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

    func getCurrentMonth() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM"
        let currentMonth = dateFormatter.string(from: currentDate)
        return currentMonth
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(UserData())
    }
}
