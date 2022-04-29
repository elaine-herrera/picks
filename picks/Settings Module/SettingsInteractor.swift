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
    
    func getCategories(){
        return model.getCategories()
    }
    
    func clearFavorites(){
        return model.clearFavorites()
    }
    
    func getUserPreferedCategories() -> Set<String> {
        let defaults = UserDefaults.standard
        let selectedCategories = defaults.object(forKey: "selectedCategories") as? [String] ?? [String]()
        return Set<String>(selectedCategories)
    }
    
    func setUserPreferedCategories(categories: Set<String>) {
        let defaults = UserDefaults.standard
        let categoriesList = [String](categories)
        let selectedCategories = defaults.object(forKey: "selectedCategories") as? [String] ?? [String]()
        
        if selectedCategories.count == categories.count {
            var differentSet = false
            for item in selectedCategories {
                if !categories.contains(item){
                    differentSet = true
                    break
                }
            }
            if differentSet {
                defaults.set(categoriesList, forKey: "selectedCategories")
                reloadByCategories(categories: categories)
            }
        }
        else {
            defaults.set(categoriesList, forKey: "selectedCategories")
            reloadByCategories(categories: categories)
        }
    }
    
    func reloadByCategories(categories: Set<String>){
        
    }
}
