//
//  SearchView.swift
//  arrivo
//
//  Created by Christian Tirado on 9/8/26.
//

import SwiftUI


struct SearchView: View {
    
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            TopNavigation {
                HStack {
                    Image("search_icon").resizable().scaledToFit().frame(
                        width: 20,
                        height: 20
                    ).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    
                    TextField("Search stops or routes", text: $searchText).foregroundStyle(Color(red: 148 / 255, green: 163 / 250, blue: 184 / 255))
                }.padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 226 / 255,  green: 232 / 255, blue: 240 / 255), lineWidth: 1)
                            )
                    )
               
            }
            VStack(alignment: .leading) {
                Text("Nearby Stops").font(.system(size: 18, weight: .bold)).padding(.bottom, 16)
                Card {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Broadway & Pike St").font(.system(size: 17, weight: .bold))
                            
                            HStack {
                                Image("map_pin_icon").resizable().scaledToFit().frame(
                                    width: 20,
                                    height: 20
                                ).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                                Text("150 ft away").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                            }
                           
                        }
                        
                        Spacer()
                    }
                   
                    
                }
            }.padding(.top,  16).padding(.horizontal, 20)
            Spacer()
        }.background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255))

    }
}

#Preview {
SearchView()
    
}
