
import Foundation
import Testing
@testable import ArrivoData
import GRDB
@testable import ArrivoData

@Test func packageLoads() {
    #expect(ArrivoData.version == "0.1.0")
}

@Test func migratorCreatesExpectedTables() throws {
    let db = try AppDatabase.empty()
    let tables = try db.reader.read { db in
        try String.fetchAll(db, sql:
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
    }
    #expect(tables.contains("favoriteStop"))
    #expect(tables.contains("feedMetadata"))
}

@Test func favoriteRoundTrips() throws {
    let db = try AppDatabase.empty()
    let stop = FavoriteStop(
        stopId: "10553231",
        stopName: "MLK EB and Beaman St",
        latitude: 35.994126,
        longitude: -83.88295)

    try db.writer.write { try stop.insert($0) }
    let fetched = try db.reader.read { try FavoriteStop.fetchOne($0, key: "10553231") }

    #expect(fetched?.stopId == stop.stopId)
    #expect(fetched?.stopName == stop.stopName)
    #expect(fetched?.latitude == stop.latitude)
    #expect(fetched?.longitude == stop.longitude)
    // Dates round-trip at millisecond resolution, so compare with tolerance
    // rather than for exact equality.
    #expect(abs(fetched!.savedAt.timeIntervalSince(stop.savedAt)) < 0.001)
}


@Test func toggleAddsThenRemoves() async throws {
    let repo = FavoritesRepository(database: try AppDatabase.empty())
    let stop = FavoriteStop(stopId: "10553231", stopName: "MLK EB and Beaman St",
                            latitude: 35.994126, longitude: -83.88295)

    #expect(try await repo.toggle(stop) == true)
    #expect(try await repo.count() == 1)
    #expect(try await repo.toggle(stop) == false)
    #expect(try await repo.count() == 0)
}

@Test func removeReturnsDeletedForUndo() async throws {
    let repo = FavoritesRepository(database: try AppDatabase.empty())
    let original = FavoriteStop(stopId: "10553231", stopName: "MLK EB and Beaman St",
                                latitude: 35.994126, longitude: -83.88295,
                                savedAt: Date(timeIntervalSince1970: 1_700_000_000))
    try await repo.add(original)

    let removed = try await repo.remove(stopId: "10553231")
    #expect(removed?.savedAt == original.savedAt)

    try await repo.add(removed!)
    #expect(try await repo.favorite(stopId: "10553231")?.savedAt == original.savedAt)
}


@Test func orderIsStableWhenTimestampsCollide() async throws {
    let repo = FavoritesRepository(database: try AppDatabase.empty())
    let t = Date(timeIntervalSince1970: 1_700_000_000)

    try await repo.add(FavoriteStop(stopId: "aaa", stopName: "A",
                                    latitude: 0, longitude: 0, savedAt: t))
    try await repo.add(FavoriteStop(stopId: "bbb", stopName: "B",
                                    latitude: 0, longitude: 0, savedAt: t))

    let before = try await repo.all().map(\.stopId)
    let removed = try await repo.remove(stopId: "aaa")
    try await repo.add(removed!)
    let after = try await repo.all().map(\.stopId)

    #expect(before == after)
}
