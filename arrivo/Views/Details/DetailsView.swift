//
//  DetailsView.swift
//  arrivo
//
//  Created by Christian Tirado on 9/5/26.
//

import SwiftUI

struct DetailsView: View {
    var body: some View {
        VStack {

            TopNavigation {
                HStack {
                    ZStack {
                        Circle().fill(
                            Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)
                        ).frame(width: 50, height: 50)

                        Image("back_arrow_icon").resizable().scaledToFit().frame(
                            width: 24,
                            height: 24
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Union Station").font(.system(size: 20, weight: .bold))

                        Text("Bay 4 • Metro Link Connection").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(
                            Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)
                        ).frame(width: 50, height: 50)

                        Image("star_icon").resizable().scaledToFit().frame(
                            width: 24,
                            height: 24
                        ).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    }

                }
                Spacer()
            }
            
            
            
            VStack {
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
                            Text("Downtown via Geary").font(.system(size: 17, weight: .bold))
                            Text("via Market St Corridor").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                        }
                        Spacer()
                   
                        LiveIndicator()
                       
                    }
                    
                    Divider().padding(.vertical, 14)
                    
                    HStack {
                        Text("Next bus").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                        Spacer()
                        HStack(alignment: .bottom){
                            Text("4 min").font(.system(size: 24, weight: .bold)).foregroundStyle(Color(red: 15 / 255, green: 23 / 250, blue: 42 / 255))
                            Text("then 15 min").font(.system(size: 15, weight: .medium)).foregroundStyle(Color(red: 148 / 255, green: 163 / 250, blue: 184 / 255))
                        }
                       
                    }
                    
                }
            }.padding(.horizontal)
            
            
            Spacer()
        }.background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255))
        
    }
}

#Preview {
    DetailsView()
}
