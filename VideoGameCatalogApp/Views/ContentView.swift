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
            ZStack{
                Image("pexels-yan-krukau-9069365").resizable().scaledToFill()
                    .ignoresSafeArea()
                VStack{
                    Image("playstation-4-game-controllers-video-game-dualshock-joystick-7d6b0eb7e10322d99b41504a05478bcc").resizable().frame(width: 105, height: 65)
                    (Text("Saved").foregroundStyle(color.DarkOrange) + Text("Games")).font(.custom("PixelifySans-VariableFont_wght", size: 32))
                Rectangle().frame(width: 350, height: 350).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                    VStack {
                        Text("Login")
                            .font(.largeTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                                .padding(.vertical, 5)
                                .padding(.horizontal, 80)
                                .background(color.DarkOrange)
                                .cornerRadius(10)
                        }
                        .padding()
                        Button(action: {
                            // Handle login action here
                            isRegestsr.toggle()
                        }) {
                            Text("Create Account").foregroundStyle(.black)
                        }
                        .padding()
                        
                    }
                    .navigationBarHidden(true)
                    .padding()
                }
                    Spacer()
            }
        }
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
