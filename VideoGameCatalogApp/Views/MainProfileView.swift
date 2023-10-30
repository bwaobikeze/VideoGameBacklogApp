import SwiftUI
import FirebaseAuth
import SlidingTabView
import FirebaseFirestore
struct favPlatformResponse: Codable{
    var name: String
}
struct MainProfileView: View {
    @State private var tabIndex = 0
    @State var username: String = "ExampleName"
    @State var platformName: String = ""
    @State var platobj = favPlatformResponse(name: "game name")
    @State private var GamePlatformsSelction = [subplatforms]()
    @State private var documentData: [String: Any] = [:]
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                ZStack{
                    Rectangle().frame(height: 250).foregroundColor(color.DarkOrange).ignoresSafeArea()
                HStack{
                    VStack{
                        Text(username).font(.custom("Poppins-SemiBold", size: 24)).foregroundStyle(.white).shadow(color: Color.black,radius: 1)
                        Text("Platform of Choice: \(platformName)").font(.custom("Poppins-Medium", size: 14)).foregroundStyle(.white).shadow(color: Color.black,radius: 1)
                    }
                    Spacer()
                    NavigationLink(destination: ProfileInfoView()) {
                        Circle().foregroundColor(.white).overlay{
                            Image("profile-user-avatar-man-person-svgrepo-com").frame(width: 90, height: 90)
                        }.frame(width: 106, height: 100)
                    }
                }
                .padding()
            }
                SlidingTabView(selection: $tabIndex, tabs: ["Recommended", "Catalog"], animation:
                        .easeInOut)
                    .padding(.top, -40)
                if tabIndex == 0 {
                    ForEach(GamePlatformsSelction, id: \.id){userPlatform in
                        
                        if userPlatform.name == platformName{
                            RecommendedView(platformNameID: userPlatform.id)

                        }
                    }
                } else if tabIndex == 1 {
                    GameCatalogView()
                }
            }
            .onAppear(perform: {
                grabProfileDate()
                Task{
                    await loadGamePlatforms()
                }
            })
        }
    }
    func loadGamePlatforms() async {
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/platforms?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(subplatformsResponse.self, from: data)
            GamePlatformsSelction = decodedGameResponse.results
        } catch {
            debugPrint(error)
        }
    }
    func grabProfileDate(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userId ?? "not id")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    // Document data is available in the "data" dictionary
                    if let name = data["username"] as? String{
                        self.username = name
                    }
                    if let platformNum = data["platform"] as? String{
                        self.platformName = platformNum
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }

}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
