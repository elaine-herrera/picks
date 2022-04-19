//
//  SettingsPresenter.swift
//  picks
//
//  Created by Elaine Herrera on 19/4/22.
//

import Foundation

class SettingsPresenter: ObservableObject {
    private let interactor: SettingsInteractor
    
    init(interactor: SettingsInteractor) {
        self.interactor = interactor
    }
    
    func clearFavorites(){
        return interactor.clearFavorites()
    }
}
