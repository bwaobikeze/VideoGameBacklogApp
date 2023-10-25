//
//  RegistrationView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/5/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var platform = 0
    @State private var username = ""
    @State private var registrationError: String?
    @State private var isRegistered = false
    @State private var GamePlatformsSelction = [subplatforms]()
    var body: some View {
        NavigationView{
            VStack {
                Text("Register")
                    .font(.largeTitle)
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
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Picker(selection: $platform) {
                    ForEach(GamePlatformsSelction, id: \.id){
                        platform in
                        Text("\(platform.name)").tag("\(platform.id)")
                    }
                } label: {
                    Text("Platforms")
                }.pickerStyle(.wheel)
                NavigationLink(destination: ContentView(), isActive: $isRegistered) {
                    EmptyView()
                }
                Button(action: {
                    // Handle registration action here
                    registerUser()
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .task{
                await loadGamePlatforms()
            }
            .padding()
        }.navigationBarBackButtonHidden(true)
        
    }
    func registerUser(){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if error != nil{print(error!.localizedDescription)} else{
                if let uid = result?.user.uid{
                    let db = Firestore.firestore()
                    let userDocREf = db.collection("users").document(uid)
                    
                    let userDate:[String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "platform": platform,
                        "username": username,
                        "uid": String(uid)
                    ]
                    userDocREf.setData(userDate){ error in
                        if let error = error{
                            print("Error creating user profile document: \(error.localizedDescription)")
                                                    self.registrationError = "Error creating user profile"
                        }else{
                            print("User registered and profile created successfully")
                            isRegistered.toggle()
                        }
                    }
                }
            }
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
