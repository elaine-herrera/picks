//
//  VimeoResponseData.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct VimeoResponseData: Codable {
    let total: Int
    let data: [Video]
}
