//
//  ContentView.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        TabView {
            ProgressView()
            .tabItem {
                Label("Picks", systemImage: "list.bullet")
            }
            ProgressView()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            ProgressView()
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
