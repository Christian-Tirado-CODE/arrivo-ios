//
//  FavoritesList.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

import SwiftUI



struct FavoritesList: View {
    let stops: [TransitStop]
    @Binding var navigationPath: NavigationPath
    let onUnfavorite: (String) -> Void

    var body: some View {
        List {

                ForEach(stops, id: \.id){stop in
                    FavoritesItem(favoriteItem: stop,
                                  onUnfavorite: { onUnfavorite(stop.id) },
                                  onSelectMoreRoutes: {
                        navigationPath.append(stop) // Programmatically navigate
                    }).listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }.onDelete { indexSet in
                    for index in indexSet {
                           onUnfavorite(stops[index].id)
                       }                }
            
           
        }.listStyle(.plain).background(Color.clear).scrollContentBackground(.hidden).navigationDestination(for: TransitStop.self) { selectedItem in
            DetailsView(transitStop: selectedItem)
        }
      
    }
}
