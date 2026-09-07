//
//  FavoriteItem.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//

import SwiftUI

struct FavoritesItem: View {
    var favoriteItem: TransitStop
    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(favoriteItem.name).font(.system(size: 17, weight: .bold))
                        Text(favoriteItem.distance).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    }
                  Spacer()
                    
                    Image("star_icon").resizable().scaledToFit().frame(
                        width: 24,
                        height: 24
                    ).foregroundStyle(Color(red: 37 / 255, green: 99 / 250, blue: 235 / 255))
                    
                }
                
                Divider()
                
                HStack {
                    

                    ForEach(favoriteItem.routes){ route in
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(route.name).font(.system(size: 12, weight: .bold)).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                                if(route.isLive){
                                    LiveIndicator()
                                }
                                else {
                                    Text("SCHEDULED").font(.system(size: 11))
                                }
                                
                            }
                            Text(route.timeOfArrival).font(.system(size: 24, weight: .bold)).foregroundStyle(Color(red: 15 / 255, green: 23 / 250, blue: 42 / 255))
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(12).background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)).cornerRadius(6)
                        
                    }
                    
                    
                 
                    
                  
                    
                }.frame(maxWidth: .infinity)
                
                Text("+ 2 more routes >").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255)).frame(maxWidth: .infinity, alignment: .leading)
                
               
                
            }.frame(maxWidth: .infinity).padding(20).background(Color.white).cornerRadius(6).overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 226 / 255, green: 232 / 250, blue: 240 / 255), lineWidth: 1)
            )
        
        }.padding(20)
    }
}


#Preview {
    HomeView()
}
