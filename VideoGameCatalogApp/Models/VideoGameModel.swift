//
//  VideoGameModel.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/8/23.
//

import Foundation
struct platform: Codable{
    var id: Int?
    var slug: String
    var name: String
}
struct Game: Codable,Identifiable{
    var id: Int
    var slug: String
    var name: String
    //var platforms: [platformObj]
    var background_image: URL
}

struct platformObj: Codable{
    var platform: [platform]
    var released_at: String
}
