//
//  VimeoDataSorce.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

struct VimeoDataSource: DataSource {
    
    func load(page: Int) -> AnyPublisher<ObservableState, Never> {
        return Future<ObservableState, Never> { promise in
            VimeoApi.shared.getStaffPicks(page: page){ result, error in
                if error == nil {
                    promise(.success((.loaded(result))))
                }
                else{
                    promise(.success(.failed(error!)))
                }
          }
        }.eraseToAnyPublisher()
    }
    
    func search(query: String, page: Int) -> AnyPublisher<ObservableState, Never> {
        return Future<ObservableState, Never> { promise in
            VimeoApi.shared.search(query: query, page: page){ result, error in
                if error == nil {
                    promise(.success((.loaded(result))))
                }
                else{
                    promise(.success(.failed(error!)))
                }
          }
        }.eraseToAnyPublisher()
    }
    
    func getCategories(page: Int) -> AnyPublisher<ObservableCategoryState, Never> {
        return Future<ObservableCategoryState, Never> { promise in
            VimeoApi.shared.getCategories(page: page){ result, error in
                if error == nil {
                    promise(.success((.loaded(result))))
                }
                else{
                    promise(.success(.failed(error!)))
                }
          }
        }.eraseToAnyPublisher()
    }
}
