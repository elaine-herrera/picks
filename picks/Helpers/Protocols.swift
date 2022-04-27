//
//  Protocols.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

protocol DataSource{
    func load(page: Int) -> AnyPublisher<ObservableState, Never>
    func search(query: String, page: Int) -> AnyPublisher<ObservableState, Never>
    func getCategories(page: Int) -> AnyPublisher<ObservableCategoryState, Never>
}

protocol Persistence{
    func load() -> AnyPublisher<ObservableState, Never>
    func save(video: Video) -> AnyPublisher<ObservableState, Never>
    func remove(video: Video) -> AnyPublisher<ObservableState, Never>
    func clear()
}
