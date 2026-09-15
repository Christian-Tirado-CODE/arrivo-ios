//
//  Route.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//


class Route: Identifiable {
    var name: String = ""
    var id: String { name }
    var timeOfArrival: String = ""
    var isLive: Bool = false
    
    init(name: String, timeOfArrival: String, isLive: Bool) {
        self.name = name
        self.timeOfArrival = timeOfArrival
        self.isLive = isLive
    }
}
