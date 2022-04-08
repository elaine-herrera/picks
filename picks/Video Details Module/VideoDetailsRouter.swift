//
//  VideoDetailsRouter.swift
//  picks
//
//  Created by Elaine Herrera on 28/3/22.
//

import SwiftUI

class VideoDetailsRouter {
    func makeVideoFooterView(for video: Video, model: DataModel) -> some View {
        let presenter = VideoPresenter(interactor: VideoInteractor(video: video, model: model))
        return VideoFooterView(presenter: presenter)
    }
}
