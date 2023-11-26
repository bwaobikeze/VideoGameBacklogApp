//
//  VideoGameModel.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/8/23.
//

import Foundation
// Represents a platform.
struct platform: Codable{
    var id: Int?
    var name: String
    var slug: String
}
// Represents a game, conforming to Codable and Identifiable.
struct Game: Codable,Identifiable{
    var id: Int
    var slug: String
    var name: String
    var released: String
    var background_image: URL?
    var platforms: [platformObj]
    var userId:String?
    var GameDataBaseID:String?
}
// Nested struct representing a platform object.
struct platformObj: Codable{
    var platform: platform
}
// Represents a game screenshot, conforming to Codable and Identifiable.
struct  GameScreenShot:Codable, Identifiable{
    var id: Int?
    var image: URL
    var width: CGFloat
    var height: CGFloat


}
// Represents a response containing an array of game screenshots.
struct  GameScreenShotResponse:Codable{
    var results:[GameScreenShot]
}
