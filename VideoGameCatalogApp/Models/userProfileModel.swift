//
//  userProfileModel.swift
//  VideoGameBackLogApp
//
//  Created by brian waobikeze on 10/7/23.
//

import Foundation
import FirebaseFirestoreSwift
struct UserProfile: Codable {
    var userID: String
    var firstName: String
    var lastName: String
    var username: String?
    var Platform: String?
}
