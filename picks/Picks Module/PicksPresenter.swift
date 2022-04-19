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
    @Published var query = ""
    private var cancellables = Set<AnyCancellable>()
    private var ruter = PicksRouter()
    
    init(interactor: PicksInteractor) {
        self.interactor = interactor
        
        interactor.model.$videos
          .assign(to: \.videos, on: self)
          .store(in: &cancellables)
        
        interactor.model.$query
          .assign(to: \.query, on: self)
          .store(in: &cancellables)
    }
    
    func loadDataIfNeeded(currentVideo: Video) {
        interactor.loadDataIfNeeded(currentVideo: currentVideo)
    }
    
    func isLoading() -> Bool {
        return interactor.isLoading()
    }
    
    func failed() -> Bool {
        return interactor.failed()
    }
    
    func getCurrentError() -> Error? {
        return interactor.getCurrentError()
    }
    
    func loadData() {
        interactor.loadData()
    }
    
    func submitCurrentSearchQuery(for query: String){
        interactor.submitCurrentSearchQuery(for: query)
    }
    
    func presentVideoView(for video: Video) -> some View {
        return ruter.makeVideoView(for: video, model: interactor.model)
    }
}

