//
//  User.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String?
    let pictures: Picture?
    let location: String?
    let shortBio: String?
    let link: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "resource_key"
        case name
        case pictures
        case location
        case shortBio = "short_bio"
        case link
    }
}

extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }
}
