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
            Text("Home").font(.title).frame(maxWidth: .infinity, alignment: .leading).padding()
            Text("Upcoming In: \(getCurrentMonth()) ").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding()

                    RoundedRectangle(cornerRadius: 15)
                         .fill(Color.white)
                         .shadow(radius: 10)
                         .frame(width: 350, height: 200)
                         .cornerRadius(15)
                         .overlay(
                             ScrollView(.horizontal) {
                                 HStack {
                                     ForEach(Games, id: \.slug) { game in
                                         Button(action: {
                                             selectedGame = game
                                         }, label: {
                                             ZStack {
                                                 AsyncImage(url: game.background_image) { image in
                                                     image.resizable()
                                                         .aspectRatio(contentMode: .fit)
                                                         .frame(maxWidth: 350, maxHeight: 200)
                                                         .cornerRadius(15)
                                                     
                                                 } placeholder: {
                                                     ProgressView()
                                                 }
                                                 
                                                 VStack {
                                                     Spacer()
                                                     Spacer()
                                                     Spacer()
                                                     HStack {
                                                         Text(game.name)
                                                             .frame(maxWidth: .infinity, alignment: .leading)
                                                             .padding(.horizontal)
                                                             .foregroundColor(Color.white)
                                                     }
                                                     Text(game.released)
                                                         .frame(maxWidth: .infinity, alignment: .leading)
                                                         .padding(.horizontal)
                                                         .foregroundColor(Color.white)
                                                     Spacer()
                                                 }
                                             }
                                             // Add some spacing between items if needed
                                         }).sheet(item: $selectedGame) { gameID in
                                             GameContentView(gameID: gameID.id)
                                         }
                                         Spacer()
                                     }
                                 }
                             }
                         )
                
            
            
            Text("Number in Catalog: ").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding()
            Text("Gaming News: ").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding()
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(articlas, id: \.title) { articla in
                        RoundedRectangle(cornerRadius: 15)
                             .fill(Color.white)
                             .shadow(radius: 10)
                             .frame(width: 350, height: 150)
                             .overlay(
                        Button(action: {
                            UIApplication.shared.open(articla.url)
                        }) {
                            AsyncImage(url: articla.urlToImage) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    .cornerRadius(30)
                            } placeholder: {
                                ProgressView()
                            }
                            Spacer()
                            Text(articla.title).frame(maxWidth: 150, maxHeight: 150).foregroundColor(.black)
                        }
                        )
                    }
                }
                .task {
                    await loadData()
                    await loadDataGame(year: 2023, month: 10)
                }
            }
        }
    }

    func loadData() async {
        let apiKeyNews = Config.newsApiKey
        guard let url = URL(string: "https://newsapi.org/v2/everything?sources=IGN,youtube&q=gaming&apiKey=\(apiKeyNews)") else {
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

    func loadDataGame(year: Int, month: Int) async {
        
        let apiKeyGame = Config.rawgApiKey
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Calculate the start and end dates for the specified month and year
        let calendar = Calendar.current
        let firstDayOfMonthComponents = DateComponents(year: year, month: month, day: 1)
        let lastDayOfMonthComponents = DateComponents(year: year, month: month + 1, day: 1)
        
        guard let firstDayOfMonth = calendar.date(from: firstDayOfMonthComponents),
              let lastDayOfMonth = calendar.date(from: lastDayOfMonthComponents) else {
            print("Invalid date components")
            return
        }
        
        let startDateString = dateFormatter.string(from: firstDayOfMonth)
        let endDateString = dateFormatter.string(from: lastDayOfMonth)
        
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&dates=\(startDateString),\(endDateString)&platforms=187&page_size=21") else {
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

        dateFormatter.dateFormat = "MMMM"
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
