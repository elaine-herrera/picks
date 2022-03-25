//
//  PicksPresenter.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Combine
import SwiftUI

class PicksPresenter: ObservableObject {
    private let interactor: PicksInteractor
    @Published var videos = [Video]()
    @Published var search = ""
    private var cancellables = Set<AnyCancellable>()
    private var ruter = PicksRouter()
    
    init(interactor: PicksInteractor) {
        self.interactor = interactor
        
        interactor.model.$videos
          .assign(to: \.videos, on: self)
          .store(in: &cancellables)
    }
    
    func loadDataIfNeeded(currentVideo: Video){
        interactor.model.loadDataIfNeeded(currentVideo: currentVideo)
    }
    
    func isLoading() -> Bool {
        return interactor.model.state == .loading
    }
    
    func failed() -> Bool {
        return interactor.model.state == .failed(ClientError.anyError)
    }
    
    func getCurrentError() -> Error? {
        return interactor.model.getCurrentError()
    }
    
    func loadData() {
        interactor.model.loadData()
    }
    
    func presentVideoView(for video: Video) -> some View {
        return ruter.makeVideoView(for: video, model: interactor.model)
    }
}

