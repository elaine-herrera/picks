//
//  Metadata.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct Metadata: Codable {
    let connections: Connections
    
    struct Connections: Codable {
        let likes: Likes
        
        struct Likes: Codable {
            let total: Int?
        }
    }
}
