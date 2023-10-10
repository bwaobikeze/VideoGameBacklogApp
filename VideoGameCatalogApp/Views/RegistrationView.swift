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
    @State private var platform = ""
    @State private var username = ""
    @State private var registrationError: String?
    @State private var isRegistered = false
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
                TextField("platform", text: $platform)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
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
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
