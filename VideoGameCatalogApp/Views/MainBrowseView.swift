//
//  MainBrowseView.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import SwiftUI

struct MainBrowseView: View {
    @State private var isSearch = false
    var body: some View {
        NavigationView{
        VStack{
            Button(action: {
                isSearch.toggle()
                print(isSearch)
            }, label: {
                Image("zoom").frame(maxWidth: .infinity, alignment: .trailing).padding()
            })
            Spacer()
            Text("Main Game Browse View")
            Spacer()
            NavigationLink(destination: BrowseSearchView(), isActive: $isSearch){
                EmptyView()
            }
        }
    }
    }
}

struct MainBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        MainBrowseView()
    }
}
