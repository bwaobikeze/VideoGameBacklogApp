//
//  NewsModel.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/8/23.
//

import Foundation
// Represents the source of a news article.
struct source:Codable{
var id:String
var name:String
}
// Represents a news article, conforming to Codable and Identifiable.
struct newsArticle: Codable, Identifiable{
    var source: source
    var title: String
    var url: URL
    var urlToImage:URL
    // Computed property for Identifiable conformance.
    var id: String{
        title
    }
}
