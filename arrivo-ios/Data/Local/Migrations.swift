import Foundation
import GRDB

extension AppDatabase {

    /// All schema changes, in order.
    ///
    /// `nonisolated` because `migrate(_:)` is called from `AppDatabase.init`,
    /// which is itself nonisolated. Each migration closure also runs on GRDB's
    /// write queue rather than the main actor.
    ///
    /// Registered migrations are immutable once shipped: to change the schema,
    /// add a NEW migration rather than editing an existing one, or installed
    /// apps will fail to migrate. GRDB tracks applied migrations by name.
    nonisolated static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
        // Wipes and rebuilds whenever a migration is edited during development.
        // Never enable this in a release build — it would delete a user's
        // favorites on any update that touches the schema.
        migrator.eraseDatabaseOnSchemaChange = true
        #endif

        // MARK: M1 — favorites

        migrator.registerMigration("createFavorites") { db in
            try db.create(table: "favoriteStop") { t in
                // GTFS stop_id as the natural primary key, so a favorite maps
                // straight onto realtime feed data. Deliberately NOT a foreign
                // key to `stop`: a GTFS re-import that drops a stop must not
                // cascade-delete the user's saved data. The denormalised name
                // and coordinates below are what let an orphaned favorite still
                // render a card reading "No longer served".
                t.primaryKey("stopId", .text)
                t.column("stopName", .text).notNull()
                t.column("latitude", .double).notNull()
                t.column("longitude", .double).notNull()
                t.column("savedAt", .datetime).notNull()
                t.column("sortOrder", .integer)
            }
        }

        migrator.registerMigration("createFeedMetadata") { db in
            // ETag, Last-Modified, lastImportedAt, content hash.
            // Lives here rather than in UserDefaults so these values commit or
            // roll back in the SAME transaction as the data they describe.
            try db.create(table: "feedMetadata") { t in
                t.primaryKey("key", .text)
                t.column("value", .text).notNull()
            }
        }

        // MARK: M2 — static GTFS (stop, route, trip)
        // MARK: M5 — stopTime, calendar, calendarDate, derived tables
        // Add here as you reach those milestones.

        return migrator
    }
}
