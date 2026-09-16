//
//  FavoritesList.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

import SwiftUI



struct FavoritesList: View {
   @Binding var transitStops: [TransitStop]
    @Binding var navigationPath: NavigationPath

    var body: some View {
        List {

                ForEach(transitStops, id: \.id){transitStop in
                    FavoritesItem(favoriteItem: transitStop, onSelectMoreRoutes: {
                        navigationPath.append(transitStop) // Programmatically navigate
                    }).listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }.onDelete { indexSet in
                    withAnimation(.snappy(duration: 0.25)) {
                        transitStops.remove(atOffsets: indexSet)
                    }
                }
            
           
        }.listStyle(.plain).background(Color.clear).scrollContentBackground(.hidden).navigationDestination(for: TransitStop.self) { selectedItem in
            DetailsView(transitStop: selectedItem)
        }
      
    }
}
