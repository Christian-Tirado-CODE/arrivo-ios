//
//  FavoriteItem.swift
//  arrivo
//
//  Created by Christian Tirado on 8/29/26.
//

import SwiftUI

struct FavoritesItem: View {
    var favoriteItem: TransitStop
    let onUnfavorite: () -> Void
    var onSelectMoreRoutes: () -> Void // Callback to trigger navigation
    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(favoriteItem.name).font(.system(size: 17, weight: .bold))
                        if let distance = favoriteItem.distance {
                               Text(distance).foregroundStyle(Color.arrivoSecondaryText)
                           }                    }
                  Spacer()
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        onUnfavorite()
                    } label: {
                        Image("star_icon").resizable().scaledToFit().frame(
                            width: 24,
                            height: 24
                        ).foregroundStyle(Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 44, height: 44, alignment: .top)
                    
                  
                    
                }
                
                Divider()
                
                HStack {
                    
                    if favoriteItem.routes.isEmpty{
                        VStack(alignment: .leading) {
                                  HStack {
                                      Text("Arrivals").font(.system(size: 12, weight: .bold))
                                          .foregroundStyle(Color.arrivoSecondaryText)
                                      Spacer()
                                  }
                                  Text("No data")
                                      .font(.system(size: 24, weight: .bold))
                                      .foregroundStyle(Color.arrivoSecondaryText)
                              }
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .frame(maxHeight: .infinity)
                              .padding(12)
                              .background(Color.arrivoTileBackground)
                              .cornerRadius(6)
                    } else {
                        ForEach(favoriteItem.routes.prefix(2)){ route in
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text(route.name).font(.system(size: 12, weight: .bold)).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                                    Spacer()
                                    if(route.isLive){
                                        LiveIndicator()
                                    }
                                    else {
                                        Text("SCHEDULED").font(.system(size: 11))
                                    }
                                    
                                }
                                Text(route.timeOfArrival).font(.system(size: 24, weight: .bold)).foregroundStyle(Color(red: 15 / 255, green: 23 / 250, blue: 42 / 255))
                            }.frame(maxWidth: .infinity, alignment: .leading).frame(maxHeight: .infinity).padding(12).background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)).cornerRadius(6)
                            
                        }

                    }
                    
                    
                    
                 
                    
                  
                    
                }.frame(maxWidth: .infinity)
                if(favoriteItem.routes.count > 2) {
                    HStack{
                        Button {
                                                    onSelectMoreRoutes()
                                                } label: {
                                                    Text("+ \(favoriteItem.routes.count - 2) more routes >")
                                                        .foregroundStyle(Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255))
                                                }
                                                .buttonStyle(.plain)
                        Spacer()
                    }
                   
                }
               
               
               
                
            }.frame(maxWidth: .infinity).padding(20).background(Color.white).cornerRadius(6).overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 226 / 255, green: 232 / 250, blue: 240 / 255), lineWidth: 1)
            )
        
        }
    }
}


#Preview {
    HomeView()
}
