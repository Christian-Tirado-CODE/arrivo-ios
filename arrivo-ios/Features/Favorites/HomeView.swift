//
//  ContentView.swift
//  arrivo
//
//  Created by Christian Tirado on 8/22/26.
//

import SwiftUI

struct HomeView: View {
    @State private var navigationPath: NavigationPath

   @State var transitStops: [TransitStop]

    init() {
        self._navigationPath = State(initialValue: NavigationPath())
        
        let transitRoutes1 = [  // Hall of Fame Dr — serves 12, 16, 20, 23, 24, 31, 32
            Route(name: "Magnolia Avenue",          timeOfArrival: "2 min",  isLive: true),   // 31
            Route(name: "Western Avenue",           timeOfArrival: "7 min",  isLive: true),   // 12
            Route(name: "Central/Clinton Hwy",      timeOfArrival: "11 min", isLive: false)   // 20
        ]
        let transitRoutes2 = [  // Magnolia Ave WB and Central St — serves 20 only
            Route(name: "Central/Clinton Hwy",      timeOfArrival: "4 min",  isLive: true)    // 20
        ]
        let transitRoutes3 = [  // Morrell Rd SB and Gleason Dr — serves 11 only
            Route(name: "Sutherland/Kingston Pike", timeOfArrival: "17 min", isLive: false)   // 11
        ]
        let transitRoutes4 = [  // Cumberland Ave WB and 11th St — serves 10, 11, 15, 17
            Route(name: "Sutherland/Kingston Pike", timeOfArrival: "11 min", isLive: true),   // 11
            Route(name: "Sutherland/Bearden",       timeOfArrival: "17 min", isLive: false)   // 17
        ]
   
        
        self._transitStops = State(initialValue: [
                    TransitStop(name: "Hall of Fame Dr SB Mid-Block before Church Ave", distance: "9 min walk • 0.5 mi", routes: transitRoutes1),
                    TransitStop(name: "Magnolia Ave WB and Central St", distance: "6 min walk • 0.3 mi", routes: transitRoutes2),
                    TransitStop(name: "Morrell Rd SB and Gleason Dr", distance: "12 min walk • 0.6 mi", routes: transitRoutes3),
                    TransitStop(name: "Cumberland Ave WB and 11th St", distance: "4 min walk • 0.2 mi", routes: transitRoutes4)
                ])
    }
    
    
    
    var body: some View {

        NavigationStack(path: $navigationPath) {
            VStack {

                SearchBar()
              
                VStack {
                    if(transitStops.count == 0) {
                        VStack {
                            Spacer()
                            Text("No favorite stops yet").font(.system(size: 20, weight: .bold)).padding(.bottom, 12)
                            Text("Search for a stop and tap the star to see live arrivals here.").font(.system(size: 14)).foregroundColor(Color(red: 100 / 255, green: 139 / 255, blue: 116 / 255)).padding(.bottom, 32)
                            Button {
                                       // Put your button tap action code here
                                       print("Find stops tapped")
                                   } label: {
                                       Text("Find stops")
                                           .font(.system(size: 18, weight: .bold)) // Bold, readable text
                                           .foregroundColor(.white)
                                           .padding(.vertical, 16)
                                           .padding(.horizontal, 40)
                                       // Vertical padding inside the button
                                                      // Stretches to fill available horizontal width
                                           .background(Color(red: 0.31, green: 0.31, blue: 0.92)) // Matches the vibrant purple/blue hue
                                           .clipShape(Capsule())                   // Forces the perfectly rounded pill shape
                                   }
                                   .padding(.horizontal, 24)
                            Spacer()
                        }
                      
                        
                    } else {
                        FavoritesList(transitStops: $transitStops, navigationPath: $navigationPath).padding(.bottom, 40)
                    }
                   

                }
                Spacer()
            }.background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255))

        }
    }
      
}

#Preview {
    HomeView()
}
