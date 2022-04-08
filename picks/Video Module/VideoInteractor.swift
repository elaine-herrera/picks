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
        model.save(video: video)
    }
    
    func removeFromFavorites(){
        model.remove(video: video)
    }
    
    func isFavorite() -> Bool {
        return model.favorites.contains(where: { $0.id == video.id })
    }
}
