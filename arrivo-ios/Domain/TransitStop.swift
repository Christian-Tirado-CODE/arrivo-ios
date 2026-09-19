//
//  FavoriteItem.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//

import Foundation

class TransitStop: Identifiable, Hashable {
    let id: String          // GTFS stop_id — needed to unfavorite and to navigate
    let name: String
    let distance: String?   // nil until CoreLocation lands (M4)
    let routes: [Route]
    
    init(id: String, name: String, distance: String?, routes: [Route]){
        self.id = id
        self.name = name
        self.distance = distance
        self.routes = routes
    }
    
    // Implement the mandatory == function
     static func == (lhs: TransitStop, rhs: TransitStop) -> Bool {
         return lhs.id == rhs.id // Compare by unique ID, or include other properties
     }
    
    // Hashable conformance
       func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
}
