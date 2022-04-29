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
    let multiSelection: Binding<Set<String>>
    private var cancellables = Set<AnyCancellable>()
    private let interactor: SettingsInteractor
    
    init(interactor: SettingsInteractor) {
        self.interactor = interactor
        
        multiSelection = Binding<Set<String>>(
          get: { interactor.getUserPreferedCategories() },
          set: { interactor.setUserPreferedCategories(categories: $0) }
        )
        
        interactor.model.$categories
          .assign(to: \.categories, on: self)
          .store(in: &cancellables)
        
        interactor.getCategories()
    }
    
    func clearFavorites(){
        return interactor.clearFavorites()
    }
}
