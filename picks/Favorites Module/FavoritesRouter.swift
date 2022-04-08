//
//  FavoritesRouter.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import SwiftUI

class FavoritesRouter{
    func makeVideoDetailView(for video: Video, model: DataModel) -> some View {
        let presenter = VideoDetailsPresenter(interactor: VideoDetailsInteractor(video: video, model: model))
        return VideoDetailsView(presenter: presenter)
    }
}
