//
//  VimeoDataSorce.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import Foundation

class VimeoDataSource<T: Codable> : DataSource {
    
    func load(request: VimeoRequest) -> AnyPublisher<ObservableState<T>, Never> {
        return Future<ObservableState<T>, Never> { promise in
            let client = VimeoAPIClient<T>()
            client.load(request: request){ result, error in
                guard let result = result else {
                    promise(.success(.failed(error ?? ClientError.anyError)))
                    return
                }
                promise(.success((.loaded(result))))
          }
        }.eraseToAnyPublisher()
    }
}
