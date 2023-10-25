//
//  ProfileInfoView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileInfoView: View {
    @ObservedObject var isLogout = determinLogout()
    var body: some View {
        NavigationView{
            VStack{
                Text("Profile info view/ logout")
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
            isLogout.isloggedOut.toggle()
            print(isLogout.isloggedOut)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}

struct ProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoView()
    }
}
