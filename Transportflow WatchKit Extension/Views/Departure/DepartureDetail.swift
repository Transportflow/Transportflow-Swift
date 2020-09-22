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
    var stop: TransportflowStop
    var departure: TransportflowStopover
    @State var upcomingStops: [TransportflowUpcomingStop]?
    @State var upcomingStopError: RequestError?
    
    func loadUpcomingStops() {
        getUpcomingStops(stop: stop, stopover: departure, provider: UserDefaults.standard.string(forKey: "provider") ?? "", success: { upcomingStops in
            self.upcomingStops = upcomingStops
        }, failure: { error in
            self.upcomingStopError = error
        })
    }
    
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
                            .frame(width: 26, height: 26, alignment: .center)
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
                    if (upcomingStops != nil) {
                        Section(header: Text("Kommende Haltestellen")) {
                            ForEach(upcomingStops!) { upcomingStop in
                                HStack {
                                    Text(upcomingStop.stop.name)
                                        .font(.caption2)
                                    Spacer()
                                    DepartureTime(when: (upcomingStop.departure ?? upcomingStop.arrival)!, relativeCalculationDate: getDateFromString(departure.when), indicatePositive: true)
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
            
            debugPrint(departure.when)
            loadUpcomingStops()
        }
    }
}
