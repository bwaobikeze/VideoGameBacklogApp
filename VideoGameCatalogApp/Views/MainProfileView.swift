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
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State private var profileImageRendered: URL?
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
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
                                AsyncImage(url: profileImageRendered) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 106, height: 100)
                                        .background(.white)
                                        .clipShape(.circle)
                                    
                                } placeholder: {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 106, height: 100)
                                        .background(.white)
                                        .clipShape(Circle())
                                }
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
        }else{
            // landscape mode UI logic
            NavigationView {
                VStack (spacing: 0) {
                    ZStack{
                        Rectangle().frame(height: 190).foregroundColor(color.DarkOrange).ignoresSafeArea().offset(y:-90)
                        HStack{
                            VStack{
                                Text(username).font(.custom("Poppins-SemiBold", size: 24)).foregroundStyle(.white).shadow(color: Color.black,radius: 1)
                                Text("Platform of Choice: \(platformName)").font(.custom("Poppins-Medium", size: 14)).foregroundStyle(.white).shadow(color: Color.black,radius: 1)
                            }
                            Spacer()
                            NavigationLink(destination: ProfileInfoView()) {
                                AsyncImage(url: profileImageRendered) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 106, height: 100)
                                        .background(.white)
                                        .clipShape(.circle)
                                    
                                } placeholder: {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 106, height: 100)
                                        .background(.white)
                                        .clipShape(Circle())
                                }
                            }
                        }.offset(y:-48)
                            .padding()
                    }
                    SlidingTabView(selection: $tabIndex, tabs: ["Recommended", "Catalog"], animation:
                            .easeInOut).offset(y:-65).ignoresSafeArea()
                    if tabIndex == 0 {
                        ForEach(GamePlatformsSelction, id: \.id){userPlatform in
                            
                            if userPlatform.name == platformName{
                                RecommendedView(platformNameID: userPlatform.id).offset(y: -60).ignoresSafeArea()
                                
                            }
                        }
                    } else if tabIndex == 1 {
                        GameCatalogView().offset(y: -60).ignoresSafeArea()
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
    }
    /*
     loadGamePlatforms():
     logic to load the different platforms
     from the api call
     */
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
    /*
     grabProfileDate():
     logic to pull the users profile
     data to be able to view
     it
     */
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
                    if let profileImage = data["profileImageURL"] as? String{
                        self.profileImageRendered = URL(string: profileImage)
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
        MainProfileView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
