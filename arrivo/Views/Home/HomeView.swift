//
//  ContentView.swift
//  arrivo
//
//  Created by Christian Tirado on 8/22/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {

            SearchBar()

            Spacer()
        }.background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255))

    }
}

#Preview {
    HomeView()
}
