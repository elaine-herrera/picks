//
//  SettingsPresenter.swift
//  picks
//
//  Created by Elaine Herrera on 19/4/22.
//

import Combine
import SwiftUI

class SettingsPresenter: ObservableObject {
    @Published var categories = [Category]()
    private var cancellables = Set<AnyCancellable>()
    private let interactor: SettingsInteractor
    
    init(interactor: SettingsInteractor) {
        self.interactor = interactor
        
        interactor.model.$categories
          .assign(to: \.categories, on: self)
          .store(in: &cancellables)
        
        interactor.getCategories()
    }
    
    func clearFavorites(){
        return interactor.clearFavorites()
    }
}
