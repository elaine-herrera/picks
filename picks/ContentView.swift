//
//  ContentView.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var model: DataModel
    
    var body: some View {
        TabView {
            PicksView(presenter: PicksPresenter(interactor: PicksInteractor(model: model)))
            .tabItem {
                Label("Picks", systemImage: "list.bullet")
            }
            ProgressView()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            FavoritesView(presenter: FavoritesPresenter(interactor: FavoritesInteractor(model: model)))
            .tabItem {
               Label("Favorites", systemImage: "star")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
