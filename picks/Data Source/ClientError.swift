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
    case appSurpassedRateLimit
    case anyError
}

extension ClientError: LocalizedError{
    public var errorDescription: String?{
        switch self {
        case .missingApiConfig:
            return "Missing Api Configutation"
        case .invalidServerResponse:
            return "Invalid Server Response"
        case .invalidAccessToken:
            return "Invalid Access Token"
        case .appSurpassedRateLimit:
            return "Application has surpassed its rate limit, or number of requests they can send in a given period of time."
        case .anyError:
            return "Unknown error"
        }
    }
}
