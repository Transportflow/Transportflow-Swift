//
//  Stop.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import SwiftUI
#if !os(watchOS)
    import SwiftUIRefresh
#endif

struct Stop: View {
    var provider: String
    var stop: TransportflowStop

    @State private var loading = true
    @State var monitor: TransportflowMonitor? = nil
    @State var error: RequestError = RequestError.nil

    func loadDepartures() {
        print("--- Departure loading")
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
        #if !os(watchOS)
        return list.listStyle(InsetGroupedListStyle()).pullToRefresh(isShowing: $loading) {
            loadDepartures()
        }
        #else
        return list
        #endif
    }
    
    var list: some View {
        List {
            #if os(watchOS)
                HStack {
                    Text(stop.name)
                        .font(.headline)
                        .truncationMode(.middle)
                        .lineLimit(2)
                    Spacer()
                    Button(action: { loadDepartures() }, label: { Label("", systemImage: "arrow.2.circlepath.circle.fill") })
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(1.2)
                        .padding()
                }
            #endif
            if (monitor != nil) {
                ForEach(monitor!.stopovers) { departure in
                    Departure(stop: stop, departure: departure)
                }
            } else {
                ErrorList(error: error)
            }
        }
        .onAppear() {
            if (monitor == nil) {
                loadDepartures()
            }
        }.navigationTitle(stop.name)

    }
}
