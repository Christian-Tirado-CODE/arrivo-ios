//
//  DetailsView.swift
//  arrivo
//
//  Created by Christian Tirado on 9/5/26.
//

import SwiftUI

struct DetailsView: View {
    let transitStop: TransitStop
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {

            TopNavigation {
                HStack {
                    ZStack {
                        Circle().fill(
                            Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)
                        ).frame(width: 50, height: 50)
                        
                        Button(action: {
                           dismiss()
                        }){
                            Image("back_arrow_icon").resizable().scaledToFit().frame(
                                width: 24,
                                height: 24
                            )
                        }
                     
                    }
                    VStack(alignment: .leading) {
                        Text("Union Station").font(.system(size: 20, weight: .bold))

                        Text("Bay 4 • Metro Link Connection").foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(
                            Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)
                        ).frame(width: 50, height: 50)

                        Image("star_icon").resizable().scaledToFit().frame(
                            width: 24,
                            height: 24
                        ).foregroundStyle(Color(red: 100 / 255, green: 116 / 250, blue: 139 / 255))
                    }

                }
                Spacer()
            }
            
            
            
            VStack {
                
                DetailsList(routes: transitStop.routes)
                
               
            }.padding(.horizontal)
            
            
            Spacer()
        }.background(Color(red: 248 / 255, green: 252 / 250, blue: 252 / 255)).navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    let transitStop = TransitStop(name: "Stop Name", distance: "0.5 miles", routes: [Route(name: "", timeOfArrival: "", isLive: true)])
                                  
                                  
   return DetailsView(transitStop: transitStop)
}
