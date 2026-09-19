//
//  FavoriteStop.swift
//  ArrivoData
//
//  Created by Christian Tirado on 9/15/26.
//

import Foundation
import GRDB

/// A stop the user has saved, mirroring the `favoriteStop` table.
///
/// This is a database record, not a domain model. It holds exactly what the
/// table holds — no arrival times, no formatted strings, no walking distance.
/// The repository maps this into whatever a view actually needs.
///
/// `stopName`, `latitude`, and `longitude` are denormalised copies of columns
/// that also live in `stop`. That duplication is deliberate: there is no
/// foreign key to `stop`, so a GTFS re-import that drops a stop leaves the
/// favorite intact and still renderable.
public struct FavoriteStop: Codable, Identifiable, Equatable, Sendable {

    /// The GTFS `stop_id`, used verbatim as the primary key so this joins
    /// directly against realtime feed data. A string per the GTFS spec, even
    /// though KAT's happen to look numeric.
    public let stopId: String

    public let stopName: String
    public let latitude: Double
    public let longitude: Double

    /// When the user favorited this stop. Drives the default list order.
    /// Restoring an undone deletion must reuse the ORIGINAL value, or the
    /// card reappears in the wrong position.
    public let savedAt: Date

    /// Reserved for manual reordering (M4). Nil until then.
    public var sortOrder: Int?

    public var id: String { stopId }

    public init(
        stopId: String,
        stopName: String,
        latitude: Double,
        longitude: Double,
        savedAt: Date = .now,
        sortOrder: Int? = nil
    ) {
        self.stopId = stopId
        self.stopName = stopName
        self.latitude = latitude
        self.longitude = longitude
        self.savedAt = savedAt
        self.sortOrder = sortOrder
    }
}

// MARK: - Persistence

extension FavoriteStop: FetchableRecord, PersistableRecord {

    /// GRDB would derive "favoriteStop" from the type name anyway; stating it
    /// means renaming the Swift type can never silently change which table
    /// this reads from.
    public static let databaseTableName = "favoriteStop"

    /// Column references for type-safe queries, so a typo is a compile error
    /// rather than a runtime one.
    public enum Columns {
        public static let stopId = Column(CodingKeys.stopId)
        public static let stopName = Column(CodingKeys.stopName)
        public static let savedAt = Column(CodingKeys.savedAt)
        public static let sortOrder = Column(CodingKeys.sortOrder)
    }
}

// MARK: - Requests

extension FavoriteStop {

    public static func orderedByDateSaved() -> QueryInterfaceRequest<FavoriteStop> {
        // stopId as a tiebreaker: savedAt is stored at millisecond resolution, so
        // two favorites added in quick succession can collide. Without a second
        // sort key, tied rows come back in arbitrary order and shift around on
        // re-insert.
        FavoriteStop.order(Columns.savedAt.desc, Columns.stopId.asc)
    }
    /// Manual order when set, falling back to newest first. Unused until M4.
    public static func orderedByUserPreference() -> QueryInterfaceRequest<FavoriteStop> {
        FavoriteStop.order(Columns.sortOrder.ascNullsLast, Columns.savedAt.desc)
    }
}
