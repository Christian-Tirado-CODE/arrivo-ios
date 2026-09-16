//
//  SearchList.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

import SwiftUI


struct SearchList: View {
    var transitStops: [TransitStop]
    
    init() {
        
        let transitRoutes1 = [Route(name: "Route 38", timeOfArrival: "2 min", isLive: true), Route(name: "Route 14", timeOfArrival: "8 min", isLive: false)]
        let transitRoutes2 = [Route(name: "Route 38", timeOfArrival: "2 min", isLive: true), Route(name: "Route 14", timeOfArrival: "8 min", isLive: false)]
        let transitRoutes3 = [Route(name: "Route 38", timeOfArrival: "2 min", isLive: true), Route(name: "Route 14", timeOfArrival: "8 min", isLive: false)]
        let transitRoutes4 = [Route(name: "Route 38", timeOfArrival: "2 min", isLive: true), Route(name: "Route 14", timeOfArrival: "8 min", isLive: false)]
        
        let transitStop1 = TransitStop(name: "Market St & 3rd Ave", distance: "2 min walk • 150 ft away", routes: transitRoutes1)
        let transitStop2 = TransitStop(name: "Market St & 3rd Ave", distance: "2 min walk • 150 ft away", routes: transitRoutes2)
        let transitStop3 = TransitStop(name: "Market St & 3rd Ave", distance: "2 min walk • 150 ft away", routes: transitRoutes3)
        let transitStop4 = TransitStop(name: "Market St & 3rd Ave", distance: "2 min walk • 150 ft away", routes: transitRoutes4)
        
        self.transitStops = [transitStop1, transitStop2, transitStop3, transitStop4]
        
    }
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                ForEach(transitStops) { transitStop in
                    SearchItem(searchItem: transitStop)
                }
            }
     
        }
        
        
    }
}


#Preview {
SearchView()
    
}
