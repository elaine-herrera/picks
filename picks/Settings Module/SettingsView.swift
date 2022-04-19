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
    
    var body: some View {
        List{
            Section(header: Text("Filters")){
                HStack{
                    Text("Categories")
                    Spacer()
                    Text("All")
                        .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
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
            Button("Cancel", role: .cancel) {
            }
        }
    }
}
