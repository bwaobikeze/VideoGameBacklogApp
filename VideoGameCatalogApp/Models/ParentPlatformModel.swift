//
//  ParentPlatformModel.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/22/23.
//

import Foundation
struct subplatforms: Codable{
    var id: Int
    var name: String
    var slug: String
    var image_background: URL

}
struct ParentPlatform: Codable{
    var id: Int
    var name: String
    var slug: String
    var platforms:[subplatforms]
}

struct PlatformResponse: Codable {
    var count: Int?
    var next: URL?
    var previous: URL?
    var results: [ParentPlatform]
}
struct subplatformsResponse: Codable{
    var results:[subplatforms]
}
