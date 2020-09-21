//
//  DepartureDetail.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 21.09.20.
//

import SwiftUI
import SDWebImageSVGCoder
import SDWebImageSwiftUI

struct DepartureDetail: View {
    var departure: TransportflowStopover
    
    var body: some View {
        VStack {
            Form {
                if (departure.cancelled ?? false) {
                    Section {
                        Text("Fällt aus")
                            .bold()
                    }
                }
                
                VStack {
                    HStack {
                        WebImage(url: URL(string: departure.line.product.img))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                        Text(departure.line.name)
                            .font(.title3)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack {
                        Text(departure.direction)
                            .font(.subheadline)
                            .lineLimit(1)
                        Spacer()
                    }
                }
            
                if (!(departure.cancelled ?? false)) {
                    Section {
                        HStack {
                            if (departure.delay != 0) {
                                VStack{
                                    Text(formatMinutes(Int(departure.delay), indicatePositive: true, longSpelling: true))
                                        .bold()
                                    Text(departure.delay > 0 ? "zu spät" : "zu früh")
                                }
                            } else {
                                Text("Pünktlich")
                                    .bold()
                            }
                            Spacer()
                            DepartureTime(when: departure.when)
                        }
                        if (departure.platform != nil) {
                            Text("Platform \(departure.platform!)")
                        }
                    }
                }
            }
        }.onAppear() {
            SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        }
    }
}
