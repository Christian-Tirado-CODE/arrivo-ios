//
//  FavoritesViewModel.swift
//  arrivo
//
//  Created by Christian Tirado on 9/16/26.
//


import Foundation
import Observation
import ArrivoData
internal import GRDB

/// Drives the Favorites screen.
///
/// `@MainActor` is explicit rather than inherited, to mark the boundary: the
/// repository and everything under it is `nonisolated`, this and everything
/// above it is main-actor. Values crossing that line are `Sendable` structs.
@MainActor
@Observable
final class FavoritesViewModel {

    // MARK: - State

    private(set) var favorites: [FavoriteStop] = []
    var stops: [TransitStop] {
        favorites.map { favorite in
            TransitStop(
                id: favorite.stopId,
                name: favorite.stopName,
                distance: nil,
                routes: [])
        }
    }

    /// Distinguishes "empty because nothing is saved" from "empty because the
    /// first emission hasn't arrived yet". Without this the empty state flashes
    /// on every launch before real data lands.
    private(set) var hasLoaded = false

    private(set) var error: Error?

    /// The most recently removed favorite, held so it can be restored.
    /// Non-nil means the undo toast is showing.
    private(set) var pendingUndo: FavoriteStop?

    var isEmpty: Bool { hasLoaded && favorites.isEmpty }

    // MARK: - Dependencies

    private let repository: FavoritesRepository
    private var undoTimer: Task<Void, Never>?

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    // MARK: - Observation

    /// Consumes the repository's change stream until the surrounding task is
    /// cancelled. Call from the view's `.task { }` modifier, which cancels
    /// automatically when the view disappears — no Task to store or tear down.
    ///
    /// The stream emits immediately with current contents and re-emits on every
    /// change, including ones made from other screens. There is no separate
    /// initial fetch and no manual refresh.
    func observeFavorites() async {
        do {
            for try await stops in repository.observeFavorites() {
                favorites = stops
                hasLoaded = true
                error = nil
            }
        } catch is CancellationError {
            // Expected when the view goes away.
        } catch {
            self.error = error
            hasLoaded = true
        }
    }

    // MARK: - Actions

    /// Removes a favorite and opens a window to undo it.
    ///
    /// The list updates itself: deleting writes to the database, which the
    /// observation picks up and re-emits. Nothing here mutates `favorites`
    /// directly, so there is only one path by which that array changes.
    func remove(stopId: String) async {
        do {
            guard let removed = try await repository.remove(stopId: stopId) else { return }
            pendingUndo = removed
            startUndoTimer()
        } catch {
            self.error = error
        }
    }

    /// Restores the last removed favorite with its ORIGINAL `savedAt`, so the
    /// card returns to the position it held rather than jumping to the top.
    func undoRemove() async {
        guard let stop = pendingUndo else { return }
        undoTimer?.cancel()
        pendingUndo = nil
        do {
            try await repository.add(stop)
        } catch {
            self.error = error
        }
    }

    func dismissUndo() {
        undoTimer?.cancel()
        pendingUndo = nil
    }

    private func startUndoTimer() {
        undoTimer?.cancel()
        undoTimer = Task { [weak self] in
            try? await Task.sleep(for: .seconds(4))
            guard !Task.isCancelled else { return }
            self?.pendingUndo = nil
        }
    }

    // MARK: - Development only
    //
    // Remove once the Search screen exists (M4). Until then there is no way to
    // get a favorite into the database.

#if DEBUG
func seedSampleStops() async {
    let now = Date()
    let samples = [
        FavoriteStop(stopId: "10553231", stopName: "MLK EB and Beaman St",
                     latitude: 35.994126, longitude: -83.88295,
                     savedAt: now.addingTimeInterval(-120)),
        FavoriteStop(stopId: "10546192", stopName: "Western Ave EB before Cherokee Health",
                     latitude: 35.967099, longitude: -83.946701,
                     savedAt: now.addingTimeInterval(-60)),
        FavoriteStop(stopId: "10555002", stopName: "White Oak Ln EB after Whittle Springs Rd",
                     latitude: 36.014583, longitude: -83.918559,
                     savedAt: now)
    ]
    do {
        for stop in samples {
            try await repository.add(stop)
        }
    } catch {
        self.error = error
    }
}
#endif
    
#if DEBUG
func clearAllFavorites() async {
    do {
        for stop in favorites {
            _ = try await repository.remove(stopId: stop.stopId)
        }
    } catch {
        self.error = error
    }
}
#endif
}
