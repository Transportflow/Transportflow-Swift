//
//  Departure.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 21.09.20.
//

import SwiftUI

struct Departure: View {
    var departure: TransportflowStopover
    @State var detailShown = false
    
    var body: some View {
        Button(action: {
            detailShown = true
        }, label: {
            VStack {
                if (departure.cancelled ?? false) {
                    Text("Fällt aus")
                        .font(.caption2)
                        .bold()
                }
                HStack {
                    VStack {
                        HStack {
                            Text(departure.line.name)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        HStack {
                            Text(departure.direction)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    Spacer()
            
                    DepartureTime(when: departure.when)
                }
            }
        }).sheet(isPresented: $detailShown, content: {
            DepartureDetail(departure: departure)
        })
    }
}
