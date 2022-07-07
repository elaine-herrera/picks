//
//  Protocols.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

protocol DataSource{
    associatedtype T: Codable
    func load(request: VimeoRequest) -> AnyPublisher<ObservableState<T>, Never>
}

protocol Persistence{
    func load() -> AnyPublisher<ObservableState<[Video]>, Never>
    func save(video: Video) -> AnyPublisher<ObservableState<[Video]>, Never>
    func remove(video: Video) -> AnyPublisher<ObservableState<[Video]>, Never>
    func clear()
}
