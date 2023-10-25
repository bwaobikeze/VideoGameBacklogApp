//
//  VideoGameModel.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/8/23.
//

import Foundation
struct platform: Codable{
    var id: Int?
    var name: String
    var slug: String
}
struct Game: Codable,Identifiable{
    var id: Int
    var slug: String
    var name: String
    var released: String
    var background_image: URL?
    var platforms: [platformObj]
    var userId:String?
}

struct platformObj: Codable{
    var platform: platform
}
