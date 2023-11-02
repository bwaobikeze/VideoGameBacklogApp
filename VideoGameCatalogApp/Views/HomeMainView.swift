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
    @State var youtubeListPointer: Int = 0
    @State private var youtubeVideosID: [String] = ["nq1M_Wc4FIc","IRNOoOYVn80","q0vNoRhuV_I", "k1kI09X8L9Y"]
    @State private var showSafari: Bool = false
    @State var urlArt: newsArticle?
    
    var body: some View {
        NavigationView{
            ScrollView(){
            VStack (spacing: 0) {
                HStack{
                    (Text("Ho").foregroundStyle(color.DarkOrange)+Text("me")).font(.custom("Poppins-SemiBold", size: 24)).frame(maxWidth: .infinity, alignment: .leading).padding(.top,8).padding(.leading, 16).offset(y:2)
                    NavigationLink(destination: ProfileInfoView()) {
                        Image("profile-user-avatar-man-person-svgrepo-com").padding()
                    }
                    
                }
                Text("Upcoming In: \(getCurrentMonth()) ").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 15).padding(.leading, 16).offset(y:-10)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .frame(width: 314, height: 200)
                    .cornerRadius(15).offset(y:-20).foregroundColor(Color.black)
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
                                                    .aspectRatio(314/200,contentMode: .fit)
                                                    .frame(maxWidth: 314 ,maxHeight: 200)
                                                    .cornerRadius(15)
                                                
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                            VStack {
                                                Spacer()
                                                Spacer()
                                                Spacer()
                                                HStack {
                                                    Text(game.name).font(.custom("Poppins-Medium", size: 20))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.horizontal)
                                                        .foregroundColor(Color.white)
                                                }
                                                Text(game.released)
                                                    .frame(maxWidth: .infinity, alignment: .leading).font(.custom("Poppins-Medium", size: 20))
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
                
                
                
                Text("Trailers: ").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).padding().offset(y:-15)
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .frame(width: 314, height: 200).offset(y:-15).overlay(
                        WebView(urlString: youtubeVideosID[youtubeListPointer]).frame(width: 314, height: 200).cornerRadius(15).offset(y:-15)
                    )
                HStack{
                    Button(action: {
                        // Handle registration action here
                        moveToPrevYoutubeVideo()
                    }) {
                        Text("Prev")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .frame(width:100, height: 20)
                            .background(color.DarkOrange)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        // Handle registration action here
                        moveToNextYoutubeVideo()
                    }) {
                        Text("Next")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .frame(width:100, height: 20)
                            .background(color.DarkOrange)
                            .cornerRadius(10)
                    }
                }
                Text("Gaming News: ").font(.custom("Poppins-Medium", size: 20)).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 8)
                    .padding(.leading, 16)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        ForEach(articlas, id: \.title) { articla in
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(radius: 10)
                                .frame(width: 281, height: 111)
                                .overlay(
                                    Button(action: {
                                        UIApplication.shared.open(articla.url)
                                    }) {
                                        AsyncImage(url: articla.urlToImage) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 127, maxHeight: 80)
                                                .cornerRadius(10)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        Spacer()
                                        Text(articla.title).font(.custom("Poppins-Medium", size: 15)).frame(maxWidth: 150, maxHeight: 150).foregroundColor(.black)
                                    }
                                ).onTapGesture {
                                    showSafari.toggle()
                            }
                            .padding()
                        }
                    }
                    .task {
                        await loadData()
                        await loadDataGame(year: 2023, month: 11)
                    }
                }
            }
        }
    }
    }
    func moveToNextYoutubeVideo(){
        youtubeListPointer = (youtubeListPointer+1)%4
    }
    func moveToPrevYoutubeVideo(){
        if youtubeListPointer == 0 {
            youtubeListPointer = 4 - 1
        } else {
            youtubeListPointer = (youtubeListPointer - 1) % 4
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
        
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKeyGame)&dates=\(startDateString),\(endDateString)&page_size=21") else {
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
