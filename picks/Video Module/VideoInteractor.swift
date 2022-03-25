//
//  VideoInteractor.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

class VideoInteractor {
    public let video: Video
    public let model: DataModel
    
    init (video: Video, model: DataModel) {
        self.video = video
        self.model = model
    }
    
    func saveToFavorites(){
        
    }
    
    func removeFromFavorites(){
        
    }
    
    func isFavorite() -> Bool {
        return false
    }
}
