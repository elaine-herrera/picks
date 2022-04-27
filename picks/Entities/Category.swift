//
//  Category.swift
//  picks
//
//  Created by Elaine Herrera on 27/4/22.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: String
    let name: String?
    let link: String?
    let topLabel: Bool?
    let isDeprecated: Bool?
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "resource_key"
        case name
        case link
        case topLabel = "top_label"
        case isDeprecated = "is_deprecated"
    }
}

extension Category: Equatable {
  static func == (lhs: Category, rhs: Category) -> Bool {
    lhs.id == rhs.id
  }
}
