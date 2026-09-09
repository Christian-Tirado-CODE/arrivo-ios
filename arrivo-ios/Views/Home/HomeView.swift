//
//  ContentView.swift
//  arrivo
//
//  Created by Christian Tirado on 8/22/26.
//

import SwiftUI

struct HomeView: View {
   
    var transitStop: TransitStop
    
    init() {
        
        let transitRoutes = [Route(name: "Route 38", timeOfArrival: "2 min", isLive: true), Route(name: "Route 14", timeOfArrival: "8 min", isLive: false)]
        self.transitStop = TransitStop(name: "Market St & 3rd Ave", distance: "2 min walk • 150 ft away", routes: transitRoutes)
        
    }
    
    
    
    var body: some View {
        
        NavigationStack {
            VStack {

                SearchBar()
                
                FavoritesItem(favoriteItem: transitStop)
                Spacer()
            }.background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)).navigationDestination(for: TransitStop.self) { selectedItem in
                DetailsView(transitStop: selectedItem)
            }

        }
    }
      
}

#Preview {
    HomeView()
}
