//
//  VimeoRequest.swift
//  picks
//
//  Created by Elaine Herrera on 6/7/22.
//

import Foundation

typealias Parameters = [String: String]

protocol VimeoRequest {
    var path: String { get }
    var parameters: Parameters { get set }
}
