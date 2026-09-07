//
//  FavoriteItem.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//

class TransitStop {
    var name: String
    var distance: String
    var routes: [Route]
    
    init(name: String, distance: String, routes: [Route]){
        self.name = name
        self.distance = distance
        self.routes = routes
    }
}
