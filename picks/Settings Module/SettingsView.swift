//
//  SettingsView.swift
//  picks
//
//  Created by Elaine Herrera on 19/4/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var presenter: SettingsPresenter
    @State private var showingClearAlert = false
    @State private var multiSelection = Set<String>()
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Filters")){
                    NavigationLink(destination: categoriesList()){
                        Text("Categories")
                    }
                }
                
                Section(header: Text("Actions")){
                    Button("Clear Favorites"){ showingClearAlert.toggle() }
                }
            }
            .navigationTitle("Settings")
            .alert("Do you want to clear your list of Favorites?", isPresented: $showingClearAlert) {
                Button("Delete", role: .destructive) {
                    presenter.clearFavorites()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    func categoriesList() -> some View {
        Group {
            if presenter.categories.isEmpty {
                ProgressView()
            }
            else {
                List(presenter.categories, id: \.id, selection: $multiSelection){ category in
                    Text(category.name ?? "Some")
                }
                .navigationBarItems(trailing: EditButton())
                .navigationTitle("Categories")
            }
        }
        
    }
}
