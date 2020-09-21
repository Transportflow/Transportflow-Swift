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
                Text(stop.name)
                    .font(.headline)
                    .truncationMode(.middle)
                    .lineLimit(2)
                Spacer()
                Button(action: {loadDepartures()}, label: {Label("", systemImage: "arrow.2.circlepath.circle.fill")})
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(1.2)
                    .padding()
            }
            if error == RequestError.nil && loading {
                Spacer()
                Text("Loading")
                Spacer()
            } else if (monitor != nil) {
                List(monitor!.stopovers) { departure in
                    Departure(departure: departure)
                }
            } else {
                ErrorList(error: error)
            }
        }
        .onAppear() {
            if (monitor == nil) {
                loadDepartures()
            }
        }
        .navigationTitle("Fahrten")
    }
}
