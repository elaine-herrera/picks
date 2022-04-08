//
//  FavoritesInteractor.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import Foundation

class FavoritesInteractor {
    let model: DataModel

    init (model: DataModel) {
        self.model = model
    }
    
    func load(){
        model.loadFavorites()
    }
    
    func save(video: Video){
        model.save(video: video)
    }
    
    func remove(video: Video){
        model.remove(video: video)
    }
    
    func clearFavorites(){
        model.clearFavorites()
    }
}
