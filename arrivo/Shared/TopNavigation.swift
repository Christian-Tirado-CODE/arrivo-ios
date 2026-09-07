//
//  TopNavigation.swift
//  arrivo
//
//  Created by Christian Tirado on 9/5/26.
//

import SwiftUI

struct TopNavigation<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack {

          content()

        }.padding(20).background(Color.white, ignoresSafeAreaEdges: []).overlay(
            Rectangle()
                .fill(Color(red: 226 / 255, green: 232 / 250, blue: 240 / 255))
                .frame(height: 1),  // Thickness of the border
            alignment: .bottom
        )
    }
}
