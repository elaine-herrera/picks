//
//  PicksRouter.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

class PicksRouter {
    func makeVideoView(for video: Video, model: DataModel) -> some View {
        let presenter = VideoPresenter(interactor: VideoInteractor(video: video, model: model))
        return VideoView(presenter: presenter)
    }
}

