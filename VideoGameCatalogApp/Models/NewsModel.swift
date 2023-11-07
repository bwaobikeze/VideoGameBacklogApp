//
//  NewsModel.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/8/23.
//

import Foundation

struct source:Codable{
var id:String
var name:String
}

struct newsArticle: Codable, Identifiable{
    var source: source
    var title: String
    var url: URL
    var urlToImage:URL
    var id: String{
        title
    }
}
