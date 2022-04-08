//
//  picksApp.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

@main
struct picksApp: App {
    let model = DataModel(dataSource: VimeoDataSource(), persistence: CoreDataPersistence())
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
