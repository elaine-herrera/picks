//
//  picksApp.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

@main
struct picksApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
