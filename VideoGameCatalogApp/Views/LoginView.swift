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

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String?
    @EnvironmentObject var userData: UserData
    @State private var isRegestsr = false
    @EnvironmentObject var settings: UserSettings
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @State private var isAlerted = false
    
    var body: some View {
        if heightSize == .regular{
            // portrait mode UI logic
            NavigationView{
                ZStack{
                    Image("sam-pak-X6QffKLwyoQ-unsplash").resizable().scaledToFill()
                        .ignoresSafeArea().blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    VStack{
                        Image("playstation-4-game-controllers-video-game-dualshock-joystick-7d6b0eb7e10322d99b41504a05478bcc").resizable().frame(width: 105, height: 65)
                        (Text("Saved").foregroundStyle(color.DarkOrange) + Text("Games")).font(.custom("SpaceMission", size: 32))
                        Rectangle().frame(width: 350, height: 350).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                            VStack {
                                Text("Login")
                                    .font(.custom("Poppins-SemiBold", size: 32))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                
                                TextField("Email", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                
                                SecureField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
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
                                .alert(isPresented: $isAlerted) {
                                    Alert(title: Text("Account does not exsit check username and password"))
                                }
                                
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
            }.navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
        }else{
            // landscape mode UI logic
            NavigationView{
                ZStack{
                    Image("sam-pak-X6QffKLwyoQ-unsplash").resizable().scaledToFill()
                        .ignoresSafeArea().blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    ScrollView(.vertical){
                        VStack{
                            Image("playstation-4-game-controllers-video-game-dualshock-joystick-7d6b0eb7e10322d99b41504a05478bcc").resizable().frame(width: 105, height: 65)
                            (Text("Saved").foregroundStyle(color.DarkOrange) + Text("Games")).font(.custom("SpaceMission", size: 32))
                            Rectangle().frame(width: 350, height: 350).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                                VStack {
                                    Text("Login")
                                        .font(.custom("Poppins-SemiBold", size: 32))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    TextField("Email", text: $email)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    SecureField("Password", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
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
                                    .alert(isPresented: $isAlerted) {
                                        Alert(title: Text("Account does not exsit check username and password"))
                                    }
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
                }
            }.navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
        }
        
    }
    /*
     Signin():
     Signs in a user with the provided email and password
     using Firebase Authentication.
     */
    func Signin(){
        Auth.auth().signIn(withEmail: email, password: password){authResult, error in
            if error != nil{
                print(error!.localizedDescription)
                isAlerted.toggle()
            }else{
                userData.userId = authResult?.user.uid
                settings.isLoggedin = true
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        LoginView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
