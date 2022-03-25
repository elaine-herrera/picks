//
//  ClientError.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

enum ClientError: Error {
    case missingApiConfig
    case invalidServerResponse
    case invalidAccessToken
    case anyError
}
