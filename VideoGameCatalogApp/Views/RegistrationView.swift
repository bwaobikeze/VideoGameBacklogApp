//
//  RegistrationView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/5/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import FirebaseStorage

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var platform = ""
    @State private var username = ""
    @State private var registrationError: String?
    @State private var isRegistered = false
    @State private var GamePlatformsSelction = [subplatforms]()
    @State private var SelectedPhotoItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var profileImaageURL: URL?
    @State var data: Data?
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
        @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    var body: some View {
        if heightSize == .regular{
            NavigationView{
                ZStack{
                    Image("sam-pak-X6QffKLwyoQ-unsplash").resizable().scaledToFill()
                        .ignoresSafeArea().blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    Rectangle().frame(width: 350, height: 550).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                        VStack {
                            Text("Create Account")
                                .font(.custom("Poppins-SemiBold", size: 20))
                                .padding()
                            ScrollView(.vertical){
                            VStack {
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
                                        Text("\(platform.name)").tag("\(platform.name)")
                                    }
                                } label: {
                                    Text("Platforms")
                                }.pickerStyle(.wheel)
                            }
                        }
                        NavigationLink(destination: ContentView(), isActive: $isRegistered) {
                            EmptyView()
                        }
                        Button(action: {
                            // Handle registration action here
                            registerUser()
                        }) {
                            Text("Create Account")
                                .font(.custom("Poppins-SemiBold", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(color.DarkOrange)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .task{
                        await loadGamePlatforms()
                    }
                    .padding()
                }
                    VStack{
                       
                        PhotosPicker(selection: $SelectedPhotoItem, matching: .images) {
                            VStack{
                                Image(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle") ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .background(.white)
                                    .clipShape(.circle)
                                Text("Add").font(.custom("Poppins-SemiBold", size: 13)).offset(y:-6)
                            }
                        }.onChange(of: SelectedPhotoItem) { _ , _ in
                            Task{
                                if let SelectedPhotoItem, let data = try? await SelectedPhotoItem.loadTransferable(type: Data.self){
                                    if let image = UIImage(data: data){
                                        avatarImage = image
                                    }
                                }
                                SelectedPhotoItem = nil
                            }
                        }
                        .onChange(of: avatarImage){
                            saveImage()
                        }
                        .offset(x:140, y:90)
                        Spacer()
                    }
                }
            }
        }else{
            NavigationView{
                ZStack{
                    Image("sam-pak-X6QffKLwyoQ-unsplash").resizable().scaledToFill()
                        .ignoresSafeArea().blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    Rectangle().frame(width: 550, height: 350).foregroundColor(color.lightGrey).cornerRadius(30).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                        VStack {
                            Text("Create Account")
                                .font(.custom("Poppins-SemiBold", size: 20))
                                .padding()
                            ScrollView(.vertical){
                            VStack {
                                
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
                                        Text("\(platform.name)").tag("\(platform.name)")
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
                                    Text("Create Account")
                                        .font(.custom("Poppins-SemiBold", size: 20))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(color.DarkOrange)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
                        }
                    }
                    .task{
                        await loadGamePlatforms()
                    }
                    .padding()
                }
                    VStack{
                       
                        PhotosPicker(selection: $SelectedPhotoItem, matching: .images) {
                            VStack{
                                Image(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle") ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .background(.white)
                                    .clipShape(.circle)
                                Text("Add Photo").font(.custom("Poppins-SemiBold", size: 13)).offset(y:-6)
                            }
                        }.onChange(of: SelectedPhotoItem) { _ , _ in
                            Task{
                                if let SelectedPhotoItem, let data = try? await SelectedPhotoItem.loadTransferable(type: Data.self){
                                    if let image = UIImage(data: data){
                                        avatarImage = image
                                    }
                                }
                                SelectedPhotoItem = nil
                            }
                        }
                        .offset(x:250, y:59)
                        Spacer()
                    }
                }
            }
        }
        
    }
    func saveImage(){
        guard let imageData = avatarImage?.jpegData(compressionQuality: 0.5) else {
                return
            }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil, error == nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "")")
                return
            }
            imageRef.downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
                    return
                }
                profileImaageURL = downloadURL
            }
            
            
            
        }
            
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
                        "uid": String(uid),
                        "profileImageURL": profileImaageURL?.absoluteString ?? "not converted string"
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
        
        RegistrationView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
