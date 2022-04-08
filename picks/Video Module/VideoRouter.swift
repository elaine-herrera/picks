//
//  VideoRouter.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

class VideoRouter {
    func makeVideoDetailView(for video: Video, model: DataModel) -> some View {
        let presenter = VideoDetailsPresenter(interactor: VideoDetailsInteractor(video: video, model: model))
        return VideoDetailsView(presenter: presenter)
    }
}
