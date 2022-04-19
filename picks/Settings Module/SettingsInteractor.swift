//
//  SettingsInteractor.swift
//  picks
//
//  Created by Elaine Herrera on 19/4/22.
//

import Foundation

class SettingsInteractor {
    public let model: DataModel

    init (model: DataModel) {
        self.model = model
    }
    
    func clearFavorites(){
        return model.clearFavorites()
    }
}
