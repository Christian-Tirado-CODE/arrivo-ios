//
//  FavoritesRe.swift
//  ArrivoData
//
//  Created by Christian Tirado on 9/15/26.
//

import Foundation
import GRDB

/// Reads and writes the user's favorited stops.
///
/// A struct holding a single reference, so it is cheap to copy and easy to
/// inject. `nonisolated` because the data layer runs off the main actor by
/// design: it hands `Sendable` values to view models, and those are the things
/// that belong on `@MainActor`.
public nonisolated struct FavoritesRepository: Sendable {

    private let database: AppDatabase

    public init(database: AppDatabase) {
        self.database = database
    }

    // MARK: - Observing

    /// A stream that emits the current favorites and then re-emits on every
    /// change — GRDB's equivalent of a Room `Flow<List<T>>`.
    ///
    /// The first element arrives immediately with current contents, so a view
    /// model can start consuming without a separate initial fetch. GRDB tracks
    /// the underlying table and only re-emits when the result actually differs.
    public func observeFavorites() -> AsyncValueObservation<[FavoriteStop]> {
        ValueObservation
            .tracking { db in
                try FavoriteStop.orderedByDateSaved().fetchAll(db)
            }
            .values(in: database.writer)
    }

    /// Whether a single stop is favorited, as a stream. Used by the star toggle
    /// on Search and Arrival Board so it stays in sync with changes made
    /// elsewhere in the app.
    public func observeIsFavorited(stopId: String) -> AsyncValueObservation<Bool> {
        ValueObservation
            .tracking { db in
                try FavoriteStop.filter(key: stopId).fetchCount(db) > 0
            }
            .values(in: database.writer)
    }

    // MARK: - Reading

    public func isFavorited(stopId: String) async throws -> Bool {
        try await database.reader.read { db in
            try FavoriteStop.filter(key: stopId).fetchCount(db) > 0
        }
    }

    public func favorite(stopId: String) async throws -> FavoriteStop? {
        try await database.reader.read { db in
            try FavoriteStop.fetchOne(db, key: stopId)
        }
    }

    public func count() async throws -> Int {
        try await database.reader.read { db in
            try FavoriteStop.fetchCount(db)
        }
    }

    // MARK: - Writing

    /// Inserts, or replaces an existing row with the same `stopId`.
    ///
    /// `save` rather than `insert` so re-favoriting a stop is not an error.
    /// Note this also powers undo: pass back the FavoriteStop that was
    /// removed, with its ORIGINAL `savedAt`, and the card returns to the
    /// position it held before deletion.
    @discardableResult
    public func add(_ stop: FavoriteStop) async throws -> FavoriteStop {
        try await database.writer.write { db in
            try stop.saved(db)
        }
    }

    /// Removes a favorite and returns it, so the caller can hold it for undo
    /// without a separate fetch. Returns nil if it was not favorited.
    @discardableResult
    public func remove(stopId: String) async throws -> FavoriteStop? {
        try await database.writer.write { db in
            guard let existing = try FavoriteStop.fetchOne(db, key: stopId) else {
                return nil
            }
            try existing.delete(db)
            return existing
        }
    }

    /// Adds if absent, removes if present. Returns the resulting state so a
    /// view can update its star without re-reading.
    ///
    /// The read and the write share one transaction, so two rapid taps cannot
    /// interleave into an inconsistent result.
    @discardableResult
    public func toggle(_ stop: FavoriteStop) async throws -> Bool {
        try await database.writer.write { db in
            if let existing = try FavoriteStop.fetchOne(db, key: stop.stopId) {
                try existing.delete(db)
                return false
            } else {
                try stop.insert(db)
                return true
            }
        }
    }

    /// Persists a manual ordering. Unused until M4.
    public func reorder(stopIds: [String]) async throws {
        try await database.writer.write { db in
            for (index, stopId) in stopIds.enumerated() {
                try db.execute(
                    sql: "UPDATE favoriteStop SET sortOrder = ? WHERE stopId = ?",
                    arguments: [index, stopId])
            }
        }
    }
}
