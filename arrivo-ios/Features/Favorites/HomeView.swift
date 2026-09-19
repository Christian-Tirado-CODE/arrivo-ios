//
//  ContentView.swift
//  arrivo
//
//  Created by Christian Tirado on 8/22/26.
//

import SwiftUI
import ArrivoData

struct HomeView: View {
    @Environment(\.appDatabase) private var database
    @State private var navigationPath = NavigationPath()
    @State private var viewModel: FavoritesViewModel?

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .bottom) {
                VStack {
                    SearchBar()

                    if let viewModel {
                        if viewModel.isEmpty {
                            emptyState(viewModel)
                        } else {
                            FavoritesList(
                                stops: viewModel.stops,
                                navigationPath: $navigationPath,
                                onUnfavorite: { stopId in
                                    Task { await viewModel.remove(stopId: stopId) }
                                }
                            )
                            .padding(.bottom, 40)
                        }
                    }

                    Spacer()
                }

                if let viewModel, let pending = viewModel.pendingUndo {
                    UndoToast(message: "Removed \(pending.stopName)") {
                        Task { await viewModel.undoRemove() }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .background(Color.arrivoBackground)
            .animation(.snappy(duration: 0.25), value: viewModel?.favorites)
            .animation(.snappy(duration: 0.25), value: viewModel?.pendingUndo)
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset", systemImage: "trash") {
                        Task { await viewModel?.clearAllFavorites() }
                    }
                }
                #endif
            }
        }
        .task {
            if viewModel == nil {
                viewModel = FavoritesViewModel(
                    repository: FavoritesRepository(database: database))
            }
            await viewModel?.observeFavorites()
        }
    }
    
    @ViewBuilder
    private func emptyState(_ viewModel: FavoritesViewModel) -> some View {
        VStack {
            Spacer()
            Text("No favorite stops yet")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 12)
            Text("Search for a stop and tap the star to see live arrivals here.")
                .font(.system(size: 14))
                .foregroundStyle(Color.arrivoSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)

            #if DEBUG
            Button {
                Task { await viewModel.seedSampleStops() }
            } label: {
                Text("Find stops")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(Color.arrivoAccent)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            #endif

            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
