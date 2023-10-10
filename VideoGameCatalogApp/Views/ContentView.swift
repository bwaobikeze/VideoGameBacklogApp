//
//  ContentView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/3/23.
//

import SwiftUI
import FirebaseAuth


class UserData: ObservableObject {
    @Published var userId: String?
}

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String?
    @EnvironmentObject var userData: UserData
    @State private var isLoggedIn = false
    @State private var isRegestsr = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                NavigationLink(destination: RegistrationView(), isActive: $isRegestsr) {
                    EmptyView()
                }
                
                Button(action: {
                    // Handle login action here
                    Signin()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                Button(action: {
                    // Handle login action here
                    isRegestsr.toggle()
                }) {
                    Text("Create an Account")
                }
                .padding()
                
            }
            .navigationBarHidden(true)
            .padding()
        }.navigationBarBackButtonHidden(true)
        
    }
    func Signin(){
        Auth.auth().signIn(withEmail: email, password: password){authResult, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                userData.userId = authResult?.user.uid
                isLoggedIn = true
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
