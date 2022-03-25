//
//  Video.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct Video: Identifiable, Codable {
    let id: String
    let name: String?
    let releaseTime: Date?
    let description: String?
    let status: String?
    let metadata: Metadata
    let pictures: Picture?
    let link: String?
    let uri: String?
    let duration: Int?
    let language: String?
    let user: User?
    
    private enum CodingKeys: String, CodingKey {
        case id = "resource_key"
        case name
        case releaseTime = "release_time"
        case description
        case status
        case metadata
        case pictures
        case link
        case uri
        case duration
        case language
        case user
    }
}

extension Video: Equatable {
  static func == (lhs: Video, rhs: Video) -> Bool {
    lhs.id == rhs.id
  }
}
