//
//  arrivoApp.swift
//  arrivo
//
//  Created by Christian Tirado on 8/22/26.
//

import SwiftUI

@main
struct ArrivoApp: App {
    let database: AppDatabase

    
    
    init() {
        do { database = try AppDatabase.makeShared() }
        catch { fatalError("Database unavailable: \(error)") }
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            
            ContentView().environment(\.appDatabase, database)        }
    }
}
