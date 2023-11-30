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
    @State private var GamePlatformsSelction = [subplatforms]()
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var settings: UserSettings
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State private var profileImageRendered: URL?
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
            NavigationView{
                ZStack{
                    // textfeilds with the users data pre-filled
                    Image("tarn-nguyen-RjXOvhpmb20-unsplash").resizable().scaledToFill()
                        .ignoresSafeArea()
                    Rectangle().frame(width: 350, height: 550).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
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
                            .offset(y:-25)
                            .padding()
                            
                        }.task{
                            await loadGamePlatforms()
                        }
                    }
                    VStack{
                        HStack(){
                            AsyncImage(url: profileImageRendered) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 106, height: 100)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .offset(x: 140, y: 45)
                                
                            } placeholder: {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 106, height: 100)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                        
                    }
                    
                    
                }.onAppear(perform: {
                    grabingProfiledetailes()
                })
                
            }.navigationViewStyle(.stack)
        }else{
            // Landscape mode UI logic
            NavigationView{
                ZStack{
                    // textfeilds with the users data pre-filled(landscape)
                    Image("tarn-nguyen-RjXOvhpmb20-unsplash").resizable().scaledToFill()
                        .ignoresSafeArea()
                    Rectangle().frame(width: 600, height: 350).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                        VStack {
                            Text("Profile")
                                .font(.custom("Poppins-SemiBold", size: 20))
                                .padding()
                            ScrollView(.vertical){
                                VStack {
                                    TextField("Username", text: $username)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    TextField("First Name", text: $firstName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    TextField("Last Name", text: $lastName)
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
                                    .offset(y: -28)
                                    .padding()
                                }
                            }
                            
                        }.task{
                            await loadGamePlatforms()
                        }
                    }.offset(y:15)
                    VStack{
                        HStack(){
                            AsyncImage(url: profileImageRendered) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 106, height: 100)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .offset(x: 290, y: 280)
                                
                            } placeholder: {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 106, height: 100)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                        
                    }
                    
                    
                }.onAppear(perform: {
                    grabingProfiledetailes()
                })
                
            }.navigationViewStyle(.stack)
        }
        
        
    }
    /*
     updateProfileData():
     logic to save update users
     info in database
     */
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
    /*
     grabingProfiledetailes():
     logic to pull the users profile
     data to be able to view and change
     it
     */
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
                    if let profileImage = data["profileImageURL"] as? String{
                        self.profileImageRendered = URL(string: profileImage)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        // A feature I will work on after the semester is over
//        if let user = Auth.auth().currentUser{
//            self.email = user.email ?? "not email"
//        }
    }
    /*
     logout():
     logic to logout of app
     */
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logout Successful")
            settings.isLoggedin.toggle()
            //            userData.userId = ""
            GamePlatformsSelction = []
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
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
}

struct ProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoView()
            .environmentObject(UserSettings())
        ProfileInfoView()
            .environmentObject(UserSettings())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
