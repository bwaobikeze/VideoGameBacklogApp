//
//  testView.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/12/23.
//

import SwiftUI

struct testView: View {
    let images = ["WFBLCCGGMFABJDBEV3FWZ4MEMU", "sord-art-online-last-recollection-button-001-1667893064956", "pexels-yan-krukau-9069365", "image4"] // Replace with
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    @State private var currentIndex = 0

    var body: some View {
        CardView(imageName: images[currentIndex], images: images)
              .frame(height: 300)
              .onReceive(timer) { _ in
                  withAnimation {
                      currentIndex = (currentIndex + 1) % images.count
                  }
              }
    }
}
struct CardView: View {
    var imageName: String
    var images: [String]


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 300)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding(10)
    }
}


#Preview {
    testView()
}
