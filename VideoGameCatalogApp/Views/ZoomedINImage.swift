//
//  ZoomedINImage.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 11/12/23.
//

import SwiftUI

struct ZoomedINImage: View {
    @State var imageZoomed: URL?
    var body: some View {
        ZStack{
            Color.black
            AsyncImage(url:  imageZoomed) { image in
                image.resizable()
                    .aspectRatio(350/350,contentMode: .fit)
                    .frame(maxWidth: 350, maxHeight:350)
            } placeholder: {
                ProgressView()
            }
        
        }.ignoresSafeArea(.all)
    }
}

#Preview {
    ZoomedINImage()
}
