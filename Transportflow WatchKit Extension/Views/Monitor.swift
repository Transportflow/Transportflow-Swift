//
//  Monitor.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI
import Alamofire

struct Monitor: View {
    var provider: String
    
    @ObservedObject var locationObserver = LocationObserver()
    @State var nearbyStops: [TransportflowStop] = []
    
    @State var loading = true
    @State var error: RequestError = RequestError.nil
    @State var stopSearch = ""
    
    @State var updateStops = false
    
    func loadStops(location: CLLocation) -> Void {
        loading = true
        
        getNearbyStops(location: locationObserver.location, provider: provider, success: { stops in
            nearbyStops = stops
            loading = false
        }, failure: { error in
            nearbyStops = []
            self.error = error
            loading = false
        })
    }
    
    var body: some View {
        VStack {
            TextField("Haltestelle", text: $stopSearch)
                
            if loading && error == RequestError.nil && nearbyStops.isEmpty {
                Spacer()
                Text("Loading")
                Spacer()
            } else {
                if !nearbyStops.isEmpty {
                    List(nearbyStops) { stop in
                        NavigationLink(stop.name, destination: Stop(provider: provider, stop: stop))
                    }
                } else {
                    ErrorList(error: error)
                }
            }
        }
        .onReceive(locationObserver.objectWillChange) {_ in
            if updateStops {
                loadStops(location: locationObserver.location)
            }
        }
        .onAppear() {
            locationObserver.start()
            updateStops = true
        }
        .onDisappear() {
            updateStops = false
        }
        .navigationTitle("Monitor")
    }
}

struct Monitor_Previews: PreviewProvider {
    static var previews: some View {
        Monitor(provider: "Dresden")
    }
}
