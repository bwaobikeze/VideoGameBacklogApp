import SwiftUI
import FirebaseAuth
import SlidingTabView

struct MainProfileView: View {
    @State private var isLogout: Bool = false
    @State private var tabIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Profile view / recommended and catalog")
                SlidingTabView(selection: $tabIndex, tabs: ["Recommended", "Catalog"], animation: .easeInOut)
                Spacer()
                
                if tabIndex == 0 {
                    RecommendedView()
                } else if tabIndex == 1 {
                    GameCatalogView()
                }
                
                Spacer()
                
                Button(action: {
                    // Handle logout action here
                    logout()
                }) {
                    Text("Logout")
                        .font(.headline)
                }
                .padding()
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logout Successful")
            isLogout.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
