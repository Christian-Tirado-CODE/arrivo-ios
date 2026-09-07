//
//  LiveIndicator.swift
//  arrivo
//
//  Created by Christian Tirado on 9/7/26.
//

import SwiftUI

struct LiveIndicator: View {
    var body: some View {
        HStack {
            ZStack {
                Circle().fill(
                    Color(red: 16 / 255, green: 185 / 250, blue: 29 / 255, opacity: 0.0824)
                ).frame(width: 12, height: 12)
                Circle().fill(
                    Color(red: 16 / 255, green: 185 / 250, blue: 29 / 255)
                ).frame(width: 6, height: 6)
                
                
                
            }
            
            
            Text("LIVE").font(.system(size: 11, weight: .bold)).foregroundStyle(Color(red: 16 / 255, green: 185 / 250, blue: 29 / 255))
        }
    }
}
