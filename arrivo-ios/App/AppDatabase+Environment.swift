//
//  AppDatabase+Environment.swift
//  arrivo
//
//  Created by Christian Tirado on 9/14/26.
//



import SwiftUI

private struct AppDatabaseKey: EnvironmentKey {
    // Force-try is acceptable: an in-memory database that fails to open means
    // the schema is broken, which should fail loudly during development.
    static let defaultValue: AppDatabase = try! .empty()
}

extension EnvironmentValues {
    var appDatabase: AppDatabase {
        get { self[AppDatabaseKey.self] }
        set { self[AppDatabaseKey.self] = newValue }
    }
}
