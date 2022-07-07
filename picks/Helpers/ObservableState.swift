//
//  ObservableState.swift
//  picks
//
//  Created by Elaine Herrera on 27/4/22.
//

import Foundation

enum ObservableState<T: Codable> {
    case idle
    case loading
    case done
    case failed(Error)
    case loaded(T)
}

extension ObservableState: Equatable{
    static func == (lhs: ObservableState, rhs: ObservableState) -> Bool {
        switch (lhs, rhs){
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.done, .done):
            return true
        case (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }
}
