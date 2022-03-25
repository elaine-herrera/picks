//
//  VimeoDataSorce.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

class VimeoDataSource: DataSource {
    
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
}