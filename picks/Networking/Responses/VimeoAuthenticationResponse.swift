//
//  AuthenticationResponse.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

struct VimeoAuthenticationResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
    }
}
