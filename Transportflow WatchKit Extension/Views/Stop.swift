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
        Form {
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
            if error == RequestError.nil && loading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if (monitor != nil) {
                Section {
                    List(monitor!.stopovers) { departure in
                        Departure(stop: stop, departure: departure)
                    }
                }
            } else {
                ErrorList(error: error)
            }
        }.onAppear() {
            if (monitor == nil) {
                loadDepartures()
            }
        }.navigationTitle(stop.name)
            .toolbar {
            #if !os(watchOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { loadDepartures() }) {
                            Text("Refresh") //Label("Refresh", systemImage: "arrow.2.circlepath.circle.fill")
                        }
                    }
                    label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            #endif

        }
    }
}
