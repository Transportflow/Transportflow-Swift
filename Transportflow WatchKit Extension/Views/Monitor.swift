//
//  Monitor.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI
import Alamofire
import CoreLocation

struct Monitor: View {
    var provider: String

    @ObservedObject var locationObserver = LocationObserver()
    @State var stops: [TransportflowStop] = []

    @State var loading = true
    @State var error: RequestError = RequestError.nil
    @State var stopSearch = ""

    func loadStops(location: CLLocation) -> Void {
        loading = true

        if stopSearch == "" {
            getNearbyStops(location: locationObserver.location, provider: provider, success: { stops in
                self.stops = stops
                loading = false
            }, failure: { error in
                    stops = []
                    self.error = error
                    loading = false
                })
        } else {
            getStops(query: stopSearch, provider: provider, success: { stops in
                self.stops = stops
                loading = false
            }, failure: { error in
                    stops = []
                    self.error = error
                    loading = false
                })
        }
    }
    
    var body: some View {
        #if !os(watchOS)
        return list.listStyle(InsetGroupedListStyle())
        #else
        return list
        #endif
    }

    var list: some View {
        List {
            HStack {
                TextField("Haltestelle", text: $stopSearch, onCommit: {
                    loadStops(location: locationObserver.location)
                })
                if loading && error == RequestError.nil && stops.isEmpty {
                    ProgressView()
                }
            }

            Section {
                if !loading && error == RequestError.nil && !stops.isEmpty {
                    ForEach(stops) { stop in
                        NavigationLink(stop.name, destination: Stop(provider: provider, stop: stop))
                    }
                } else if !loading {
                    ErrorList(error: error)
                }
            }

        }
            .navigationTitle("Monitor")
            .onReceive(locationObserver.objectWillChange) { _ in
            loadStops(location: locationObserver.location)
        }
            .onAppear() {
            locationObserver.start()
        }

    }
}

struct Monitor_Previews: PreviewProvider {
    static var previews: some View {
        Monitor(provider: "Dresden")
    }
}
