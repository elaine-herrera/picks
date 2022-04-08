//
//  FavoritesPresenter.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import Combine
import SwiftUI

class FavoritesPresenter: ObservableObject {
    private let interactor: FavoritesInteractor
    @Published var favorites = [Video]()
    private var cancellables = Set<AnyCancellable>()
    private let router = FavoritesRouter()

    init(interactor: FavoritesInteractor) {
        self.interactor = interactor
        interactor.model.$favorites
          .assign(to: \.favorites, on: self)
          .store(in: &cancellables)
    }
    
    func isEmpty() -> Bool {
        return favorites.isEmpty
    }
    
    func linkBuilder<Content: View>(for video: Video, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeVideoDetailView(for: video, model: interactor.model)) {
            content()
        }
        .buttonStyle(.plain)
    }
}
