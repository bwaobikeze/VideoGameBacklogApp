//
//  ProfileInfoView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileInfoView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var platform = ""
    @State private var username = ""
    @ObservedObject var isLogout = determinLogout()
    @State private var GamePlatformsSelction = [subplatforms]()
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView{
            ZStack{
                Image("tarn-nguyen-RjXOvhpmb20-unsplash").resizable().scaledToFill()
                    .ignoresSafeArea()
                Rectangle().frame(width: 350, height: 650).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                    VStack {
                        Text("Profile")
                            .font(.largeTitle)
                            .padding()
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Picker(selection: $platform) {
                            ForEach(GamePlatformsSelction, id: \.id){
                                platform in
                                Text("\(platform.name)").tag("\(platform.name)")
                            }
                        } label: {
                            Text("Platforms")
                        }.pickerStyle(.wheel).frame(maxWidth: 300, maxHeight: 60)
                        Button(action: {
                            // Handle registration action here
                            updateProfileData()
                        }) {
                            Text("Update Profile")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth:200, minHeight:30)
                                .background(color.DarkOrange)
                                .cornerRadius(10)
                            
                        }
                        Text("-or-")
                        Button(action: {
                            // Handle logout action here
                            logout()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .frame(maxWidth:200, minHeight:30)
                                .foregroundColor(.black)
                                .background(color.lightGrey)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                    }.task{
                        await loadGamePlatforms()
                    }
                }
                VStack{
                    HStack(){
                        Circle().foregroundColor(.white).overlay{
                            Image("profile-user-avatar-man-person-svgrepo-com").aspectRatio(106/100,contentMode: .fit)
                        }.frame(width: 106, height: 100).offset(x: 140)
                    }
                    Spacer()
                    
                }
                

            }.onAppear(perform: {
                grabingProfiledetailes()
            })
            
                    
                

            
        }
        
    }
    func updateProfileData(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userId ?? "not id")
        let newData:[String: Any] = [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "platform":self.platform,
            "username": self.username
        ]
        
        docRef.updateData(newData){error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    func grabingProfiledetailes(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userId ?? "not id")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    // Document data is available in the "data" dictionary
                    if let name = data["username"] as? String{
                        self.username = name
                    }
                    if let FirstName = data["firstName"] as? String{
                        self.firstName = FirstName
                    }
                    if let LastName = data["lastName"] as? String{
                        self.lastName = LastName
                    }
                    if let PlatformNum = data["platform"] as? String{
                        self.platform = PlatformNum
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        if let user = Auth.auth().currentUser{
            self.email = user.email ?? "not email"
        }
    }
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logout Successful")
            isLogout.isloggedOut.toggle()
            print(isLogout.isloggedOut)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
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
}

struct ProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoView()
    }
}
