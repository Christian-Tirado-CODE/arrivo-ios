//
//  DetailsItem.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

//
//  FavoriteItem.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//

import SwiftUI

struct DetailsItem: View {
    var route: Route
    var body: some View {
        Card{
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255, )
                        )
                        .frame(width: 40, height: 40)
                    Text("38").foregroundStyle(Color.white).fontWeight(.bold)
                }
               
                VStack {
                    Text(route.name).font(.system(size: 17, weight: .bold))
             
                }
                Spacer()
           
                
                if(route.isLive){
                    LiveIndicator()
                }
                else {
                    Text("SCHEDULED").font(.system(size: 11))
                }
               
            }
            
            Divider().padding(.vertical, 14)
            
            HStack {
                Text("Next bus").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                Spacer()
                HStack(alignment: .bottom){
                    Text(route.timeOfArrival).font(.system(size: 24, weight: .bold)).foregroundStyle(Color(red: 15 / 255, green: 23 / 250, blue: 42 / 255))
                    Text("then 15 min").font(.system(size: 15, weight: .medium)).foregroundStyle(Color(red: 148 / 255, green: 163 / 250, blue: 184 / 255))
                }
               
            }
            
        }
    }
}


#Preview {
    SearchView()
}
