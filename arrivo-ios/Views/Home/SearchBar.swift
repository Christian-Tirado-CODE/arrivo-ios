//
//  SearchBar.swift
//  arrivo
//
//  Created by Christian Tirado on 8/24/26.
//

import SwiftUI

struct SearchBar: View {
    var body: some View {
        HStack {

            
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255, )
                    )
                    .frame(width: 40, height: 40)
                Image("airplane").resizable().scaledToFit().frame(
                    width: 24,
                    height: 24
                )
            }

            Text("Favorites").font(.system(size: 30, weight: .bold))
            Spacer()

          

        }.padding(20).background(Color.white, ignoresSafeAreaEdges: []).overlay(
            Rectangle()
                .fill(Color(red: 226 / 255, green: 232 / 250, blue: 240 / 255))
                .frame(height: 1),  // Thickness of the border
            alignment: .bottom
        )
    }
}
