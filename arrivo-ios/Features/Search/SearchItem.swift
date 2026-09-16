//
//  SearchItem.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

import SwiftUI


struct SearchItem: View {
    var searchItem: TransitStop
    var body: some View {
        Card {
            HStack {
                VStack(alignment: .leading) {
                    Text(searchItem.name).font(.system(size: 17, weight: .bold))
                    
                    HStack {
                        Image("map_pin_icon").resizable().scaledToFit().frame(
                            width: 20,
                            height: 20
                        ).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                        Text(searchItem.distance).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    }
                   
                }
                
                Spacer()
            }
           
            
        }
    }
}


#Preview {
SearchView()
    
}
