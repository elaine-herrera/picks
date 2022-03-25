//
//  VideoPresenter.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import SwiftUI

class VideoPresenter: ObservableObject {
    @Published var video: Video
    private let interactor: VideoInteractor
    private let router = VideoRouter()
    
    init(interactor: VideoInteractor) {
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
    
    func linkBuilder<Content: View>(for video: Video, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeVideoDetailView(for: video, model: interactor.model)) {
            content()
        }
        .buttonStyle(.plain)
    }
}
