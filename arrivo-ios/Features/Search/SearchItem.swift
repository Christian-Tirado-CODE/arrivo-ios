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
                    
                    if let distance = searchItem.distance {
                        HStack {
                            Image("map_pin_icon")
                                .resizable().scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.arrivoSecondaryText)
                            Text(distance)
                                .foregroundStyle(Color.arrivoSecondaryText)
                        }
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
