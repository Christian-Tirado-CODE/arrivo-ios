//
//  DetailsList.swift
//  arrivo
//
//  Created by Christian Tirado on 9/9/26.
//

import SwiftUI

struct DetailsList: View {
    var routes: [Route]

    var body: some View {
        ScrollView {
            ForEach(routes){route in
                DetailsItem(route: route)
            }
        }
      
    }
}
