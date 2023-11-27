//
//  ZoomedINImage.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 11/12/23.
//

import SwiftUI

struct ZoomedINImage: View {
    @State var imageZoomed: URL?
    @Environment(\.verticalSizeClass) var heightSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSize: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        if heightSize == .regular{
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
        }else{
            GeometryReader { geometry in
            ZStack{
                Color.black
                AsyncImage(url:  imageZoomed) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame( maxHeight:geometry.size.height)
                } placeholder: {
                    ProgressView()
                }
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(color.DarkOrange)
                        .frame(width: 50, height: 100)
                }).offset(x: -360, y: -150)
                
            }.ignoresSafeArea(.all)
        }
        }

    }
}

struct ZoomedINImage_Previews: PreviewProvider {
    static var previews: some View {
        ZoomedINImage()
        ZoomedINImage()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

