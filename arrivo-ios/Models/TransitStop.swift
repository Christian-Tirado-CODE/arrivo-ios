//
//  FavoriteItem.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//

import Foundation

class TransitStop: Identifiable, Hashable {
    var name: String
    var distance: String
    var routes: [Route]
    
    init(name: String, distance: String, routes: [Route]){
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
