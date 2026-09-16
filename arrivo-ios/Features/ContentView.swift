//
//  ContentView.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab){
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "star")
                }
            
         SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        
    }
}

#Preview {
    ContentView()
}
