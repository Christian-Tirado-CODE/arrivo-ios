//
//  Card.swift
//  arrivo
//
//  Created by Christian Tirado on 9/5/26.
//

import SwiftUI

struct Card<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            content()
        }.frame(maxWidth: .infinity).padding(20).background(Color.white).cornerRadius(6).overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 226 / 255, green: 232 / 250, blue: 240 / 255), lineWidth: 1)
        )
    }
}


#Preview {
    DetailsView()
}
