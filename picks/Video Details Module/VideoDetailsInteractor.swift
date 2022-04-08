//
//  VideoDetailsInteractor.swift
//  picks
//
//  Created by Elaine Herrera on 28/3/22.
//

import Combine
import Foundation

class VideoDetailsInteractor {
    public let video: Video
    public let model: DataModel

    private var cancellables = Set<AnyCancellable>()

    init (video: Video, model: DataModel) {
        self.video = video
        self.model = model
    }
    
    func saveToFavorites(){
        return model.save(video: video)
    }
    
    func removeFromFavorites(){
        return model.remove(video: video)
    }
    
    func isFavorite() -> Bool {
        return model.favorites.contains(where: { $0.id == video.id })
    }
}

