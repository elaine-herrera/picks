//
//  FavoritesView.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var presenter: FavoritesPresenter
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            if presenter.isEmpty(){
                EmptyFavView()
            }
            else{
                List{
                    ForEach(searchResults){ video in
                        self.presenter.linkBuilder(for: video) {
                            FavoriteRowView(video: video)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "Look for something")
                .navigationTitle("Favorites")
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var searchResults: [Video] {
        if searchText.isEmpty {
            return presenter.favorites
        } else {
            return presenter.favorites.filter { $0.name?.contains(searchText) ?? false || $0.description?.contains(searchText) ?? false || $0.user?.name?.contains(searchText) ?? false || $0.user?.shortBio?.contains(searchText) ?? false}
        }
    }
}
