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
    @State var platformIDNumber: Int = 0
    @State var platobj = favPlatformResponse(name: "game name")
    @State private var documentData: [String: Any] = [:]
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack{
                    VStack{
                        Text(username)
                        Text("Platform of Choice: \(platobj.name)")
                    }
                    Spacer()
                    NavigationLink(destination: ProfileInfoView()) {
                        Image("profile-user-avatar-man-person-svgrepo-com")
                    }
                }
                .padding()
                SlidingTabView(selection: $tabIndex, tabs: ["Recommended", "Catalog"], animation: .easeInOut)
                Spacer()
                
                if tabIndex == 0 {
                    RecommendedView()
                } else if tabIndex == 1 {
                    GameCatalogView()
                }
                
                Spacer()
            }
            .onAppear(perform: {
                grabProfileDate()
            })
            .task {
                await loadFavPlatform()
            }
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
                    if let platformNum = data["platform"] as? Int{
                        self.platformIDNumber = platformNum
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    func loadFavPlatform() async {
        let apiKeyGame=Config.rawgApiKey
        guard let url = URL(string: "https://api.rawg.io/api/platforms/\(platformIDNumber)?key=\(apiKeyGame)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGameResponse = try JSONDecoder().decode(favPlatformResponse.self, from: data)
            platobj = decodedGameResponse
        } catch {
            debugPrint(error)
        }
    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
