//
//  VideoDetailsPresenter.swift
//  picks
//
//  Created by Elaine Herrera on 28/3/22.
//

import Combine
import SwiftUI

class VideoDetailsPresenter: ObservableObject {
    @Published var video: Video
    private let interactor: VideoDetailsInteractor
    private var cancellables = Set<AnyCancellable>()
    private var ruter = VideoDetailsRouter()
    
    init(interactor: VideoDetailsInteractor) {
        self.interactor = interactor
        self.video = interactor.video
    }
    
    func saveToFavorites(){
        return interactor.saveToFavorites()
    }
    
    func removeFromFavorites(){
        return interactor.removeFromFavorites()
    }
    
    func isFavorite() -> Bool {
        return interactor.isFavorite()
    }
    
    func presentVideoFooterView() -> some View {
        return ruter.makeVideoFooterView(for: video, model: interactor.model)
    }
}
