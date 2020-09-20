//
//  Stop.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import SwiftUI

struct Stop: View {
    var provider: String
    var stop: TransportflowStop
    
    @State var loading = false
    @State var monitor: TransportflowMonitor? = nil
    @State var error: RequestError = RequestError.nil
    
    
    
    func loadDepartures() {
        
        loading = true
        getDepartures(stop: stop, provider: provider, success: { monitor in
            self.error = RequestError.nil
            self.monitor = monitor
            loading = false
        }, failure: { error in
            monitor = nil
            self.error = error
            loading = false
        })
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(monitor?.stop.name ?? "")")
                    .font(.headline)
                Spacer()
            }
            if error == RequestError.nil && loading {
                Spacer()
                Text("Loading")
                Spacer()
            } else if (monitor != nil) {
                List(monitor!.stopovers) { departure in
                    HStack {
                        VStack {
                            HStack {
                                Text(departure.line.name)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            HStack {
                                Text(departure.direction)
                                Spacer()
                            }
                        }
                        Spacer()
                        
                        DepartureTime(when: departure.when)
                    }
                }
            } else {
                ErrorList(error: error)
            }
        }
        .onAppear() {
            loadDepartures()
        }
        .navigationTitle("Abfahrten")
    }
}
