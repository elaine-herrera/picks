//
//  PicksInteractor.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

class PicksInteractor {
    let model: DataModel

    init (model: DataModel) {
        self.model = model
    }
    
    func loadDataIfNeeded(currentVideo: Video) {
        model.loadDataIfNeeded(currentVideo: currentVideo)
    }
    
    func isLoading() -> Bool {
        return model.state == .loading
    }
    
    func failed() -> Bool {
        return model.state == .failed(ClientError.anyError)
    }
    
    func getCurrentError() -> Error? {
        return model.getCurrentError()
    }
    
    func loadData() {
        model.loadData()
    }
    
    func submitCurrentSearchQuery(for query: String){
        model.performSearch(for: query)
    }
}
