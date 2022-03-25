//
//  Picture.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct Picture: Codable {
    let sizes: [Image]
    
    private enum CodingKeys: String, CodingKey {
        case sizes = "sizes"
    }
    
    struct Image: Codable {
        let height: Int
        let width: Int
        let linkWithPlayButton: String?
        let link: String
        
        private enum CodingKeys: String, CodingKey {
            case height
            case width
            case linkWithPlayButton = "link_with_play_button"
            case link
        }
    }
}
