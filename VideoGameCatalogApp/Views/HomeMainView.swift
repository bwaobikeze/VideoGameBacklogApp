import SwiftUI
import FirebaseStorage
import FirebaseFirestore

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
    @State private var urlArt: newsArticle?
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State private var currentIndex = 0
    @State private var profileImageRendered: URL?
    
    var body: some View {

            // Regular IPhone UI
            if heightSize == .regular{
                // portrait mode UI logic
                NavigationView{
                    ScrollView(){
                        VStack (spacing: 0) {
                            HStack{
                                (Text("Ho").foregroundStyle(color.DarkOrange)+Text("me")).font(.custom("Poppins-SemiBold", size: 24)).frame(maxWidth: .infinity, alignment: .leading).padding(.top,8).padding(.leading, 16).offset(y:2)
                                NavigationLink(destination: ProfileInfoView()) {
                                    AsyncImage(url: profileImageRendered) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .background(.white)
                                            .clipShape(.circle)
                                        
                                    } placeholder: {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
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
                                        Button(action: {
                                            urlArt = articla
                                        } , label: {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.white)
                                                .shadow(radius: 10)
                                                .frame(width: 281, height: 111)
                                                .overlay{
                                                    HStack{
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
                                                        
                                                    } }.padding()
                                        }).fullScreenCover(item: $urlArt) { Identifiable in
                                            SFSafariViewWrapper(url: Identifiable.url)
                                        }
                                    }
                                }
                                .task {
                                    await loadData()
                                    await loadDataGame(year: 2023, month: 11)
                                }
                            }
                        }
                    }
                }.navigationViewStyle(.stack)
                .onAppear {
                    loadProfileImage()
                }
            }else{
                // landscape mode UI logic
                NavigationView{
                    ScrollView(){
                        VStack (spacing: 0) {
                            HStack{
                                (Text("Ho").foregroundStyle(color.DarkOrange)+Text("me")).font(.custom("Poppins-SemiBold", size: 35)).frame(maxWidth: .infinity, alignment: .leading).padding(.top,8).padding(.leading, 16).offset(y:2)
                                NavigationLink(destination: ProfileInfoView()) {
                                    
                                    AsyncImage(url: profileImageRendered) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .background(.white)
                                            .clipShape(.circle)
                                        
                                    } placeholder: {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                    .padding()
                                }
                                
                            }
                            Text("Upcoming In: \(getCurrentMonth()) ").font(.custom("Poppins-Medium", size: 40)).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 15).padding(.leading, 16).offset(y:-10)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black)
                                .shadow(radius: 10)
                                .frame(width: 600, height: 300)
                                .cornerRadius(15).foregroundColor(Color.black)
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
                                                                .aspectRatio(600/300,contentMode: .fit)
                                                                .frame(maxWidth: 600 ,maxHeight: 300)
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
                            
                            
                            
                            Text("Trailers: ").font(.custom("Poppins-Medium", size: 40)).frame(maxWidth: .infinity, alignment: .leading).padding().offset(y:-15)
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(radius: 10)
                                .frame(width: 600, height: 300).offset(y:-15).overlay(
                                    WebView(urlString: youtubeVideosID[youtubeListPointer]).frame(width: 600, height: 300).cornerRadius(15).offset(y:-15)
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
                            Text("Gaming News: ").font(.custom("Poppins-Medium", size: 40)).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 8)
                                .padding(.leading, 16)
                            
                            ScrollView(.horizontal) {
                                LazyHStack(spacing: 8) {
                                    ForEach(articlas, id: \.title) { articla in
                                        Button(action: {
                                            urlArt = articla
                                        } , label: {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.white)
                                                .shadow(radius: 10)
                                                .frame(width: 281, height: 111)
                                                .overlay{
                                                    HStack{
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
                                                        
                                                    } }.padding()
                                        }).fullScreenCover(item: $urlArt) { Identifiable in
                                            SFSafariViewWrapper(url: Identifiable.url)
                                        }
                                    }
                                }
                                
                                .task {
                                    await loadData()
                                    await loadDataGame(year: 2023, month: 11)
                                }
                            }
                        }
                    }
                }.navigationViewStyle(.stack)
                .onAppear {
                    loadProfileImage()
                }
            }
        
    }
    /*
     moveToNextYoutubeVideo():
     Moves to the next video in the YouTube list.
     */
    func moveToNextYoutubeVideo(){
        youtubeListPointer = (youtubeListPointer+1)%4
    }
    /*
     moveToPrevYoutubeVideo():
     Moves to the previous video in the YouTube list,
     looping back to the last video if at the first one.
     */
    func moveToPrevYoutubeVideo(){
        if youtubeListPointer == 0 {
            youtubeListPointer = 4 - 1
        } else {
            youtubeListPointer = (youtubeListPointer - 1) % 4
        }
    }
    /*
     loadData():
     Loads news articles related to gaming from the News API
     using the configured API key.
     */
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
    /*
     loadProfileImage():
     Loads the user's profile image from Firestore
     based on the user ID.
     */
    func loadProfileImage(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userId ?? "not id")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    // Document data is available in the "data" dictionary
                    if let profileImage = data["profileImageURL"] as? String{
                        self.profileImageRendered = URL(string: profileImage)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    /*
     loadDataGame():
     Loads game data from the RAWG API for a
     specific month and year.
     */
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
    /*
     getCurrentMonth():
     Gets the name of the current month.
     */
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
        HomeMainView()
            .environmentObject(UserData())
            .previewInterfaceOrientation(.landscapeLeft)
        
//        HomeMainView()
//            .environmentObject(UserData())
//            .previewDevice("iPad (10th generation)")
//        HomeMainView()
//            .environmentObject(UserData())
//            .previewDevice("iPad (10th generation)")
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
