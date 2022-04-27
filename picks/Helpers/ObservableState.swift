//
//  ObservableState.swift
//  picks
//
//  Created by Elaine Herrera on 27/4/22.
//

import Foundation

enum ObservableState {
    case idle
    case loading
    case failed(Error)
    case loaded([Video])
}

enum ObservableCategoryState {
    case idle
    case loading
    case failed(Error)
    case loaded([Category])
}

extension ObservableState: Equatable{
    static func == (lhs: ObservableState, rhs: ObservableState) -> Bool {
        switch (lhs, rhs){
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }
}

extension ObservableCategoryState: Equatable{
    static func == (lhs: ObservableCategoryState, rhs: ObservableCategoryState) -> Bool {
        switch (lhs, rhs){
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }
}
