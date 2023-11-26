//
//  ParentPlatformModel.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/22/23.
//

import Foundation
// Represents subplatform information, conforming to Codable.
struct subplatforms: Codable{
    var id: Int
    var name: String
    var slug: String
    var image_background: URL

}
// Represents parent platform information, conforming to Codable.

struct ParentPlatform: Codable{
    var id: Int
    var name: String
    var slug: String
    var platforms:[subplatforms]
}
// Represents the response for platforms, conforming to Codable.
struct PlatformResponse: Codable {
    var count: Int?
    var next: URL?
    var previous: URL?
    var results: [ParentPlatform]
}
// Represents the response for subplatforms, conforming to Codable.
struct subplatformsResponse: Codable{
    var results:[subplatforms]
}
