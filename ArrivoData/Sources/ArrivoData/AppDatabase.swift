import Foundation
import GRDB
import os

// MARK: - Logging
//
// `nonisolated` because this is read from GRDB's database queue, which is not
// main-actor isolated. Under Swift 6.2's MainActor default isolation, an
// unannotated `static let` here would be inferred as @MainActor and fail to
// compile at the call site in `makeConfiguration()`.
//
// The subsystem is a plain constant rather than `Bundle.main.bundleIdentifier`
// for the same reason: `Bundle.main` is main-actor isolated, so touching it
// from a nonisolated context is an error.

nonisolated let arrivoSubsystem = "com.yourname.arrivo"

extension Logger {
    nonisolated static let database = Logger(subsystem: arrivoSubsystem,
                                             category: "database")
}

// MARK: - AppDatabase

/// Owns the app's single database connection.
///
/// Explicitly `nonisolated`: the data layer runs off the main actor by design.
/// It hands `Sendable` values to view models, which are the things that should
/// be `@MainActor`. Keeping that line sharp is what stops isolation errors from
/// appearing one at a time at every callback boundary.
public nonisolated final class AppDatabase: Sendable {

    /// `DatabaseWriter` rather than a concrete type so tests and previews can
    /// substitute an in-memory `DatabaseQueue` for the on-disk `DatabasePool`.
    /// GRDB 7's `DatabaseWriter` inherits `Sendable`, which is what allows this
    /// class to be `Sendable` while holding it.
    public let writer: any DatabaseWriter

    /// Reads go through the same object; the protocol exposes `read` too.
  public var reader: any DatabaseReader { writer }

    public init(_ writer: any DatabaseWriter) throws {
        self.writer = writer
        try Self.migrator.migrate(writer)
    }
}

// MARK: - Factories

extension AppDatabase {

    /// The production database, stored in Application Support.
    ///
    /// `nonisolated` so this can be called from a background task later (for
    /// example, if the import ever needs to open the database outside app
    /// launch) without a second round of isolation errors.
public nonisolated static func makeShared() throws -> AppDatabase {
        let fileManager = FileManager.default

        // Application Support is NOT created for you, and neither is our
        // subdirectory. Forgetting this is a classic first-launch crash.
        let directory = try fileManager
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(arrivoSubsystem, isDirectory: true)

        try fileManager.createDirectory(at: directory,
                                        withIntermediateDirectories: true)

        // Apply file protection to the DIRECTORY so the -wal and -shm siblings
        // inherit it. `.completeUntilFirstUserAuthentication` lets a background
        // refresh write while the device is locked; `.complete` would not.
        try fileManager.setAttributes(
            [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
            ofItemAtPath: directory.path)

        let url = directory.appendingPathComponent("arrivo.sqlite")

        // DatabasePool, not DatabaseQueue. The GTFS import holds a multi-second
        // write transaction; a pool lets readers keep seeing the previous
        // snapshot so the Favorites screen stays live during a refresh.
        // A pool requires WAL mode, which GRDB enables for us.
        let pool = try DatabasePool(path: url.path, configuration: makeConfiguration())

        Logger.database.info("Opened database at \(url.path, privacy: .public)")
        return try AppDatabase(pool)
    }

    /// An empty in-memory database for tests and SwiftUI previews.
    /// Migrations run, so the schema matches production exactly.
  public nonisolated static func empty() throws -> AppDatabase {
        try AppDatabase(DatabaseQueue(configuration: makeConfiguration()))
    }
}

// MARK: - Configuration

extension AppDatabase {

    nonisolated static func makeConfiguration(
        _ base: Configuration = Configuration()
    ) -> Configuration {
        var config = base

        // On by default in GRDB. Stated explicitly because the GTFS import
        // deliberately toggles this off inside its transaction.
        config.foreignKeysEnabled = true

        // The import holds a long write transaction while loading tens of
        // thousands of rows. Give concurrent readers room to wait it out.
        config.busyMode = .timeout(10)

        #if DEBUG
        // Echo SQL to the console and let GRDB print statement arguments.
        // Both are stripped from release builds: arguments can contain user
        // data, and OSLog persists to disk on device.
        //
        // This closure runs on GRDB's own queue — the reason `Logger.database`
        // above has to be nonisolated.
        config.publicStatementArguments = true
        config.prepareDatabase { db in
            db.trace { event in
                Logger.database.debug("\(event.expandedDescription, privacy: .public)")
            }
        }
        #endif

        return config
    }
}



