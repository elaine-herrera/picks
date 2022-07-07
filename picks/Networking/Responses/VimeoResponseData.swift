//
//  VimeoResponseData.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct VimeoResponseData<T: Codable>: Codable {
    let total: Int
    let data: [T]
}
