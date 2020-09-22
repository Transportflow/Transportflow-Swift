//
//  ErrorList.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import SwiftUI

struct ErrorList: View {
    @State var error: RequestError
    
    var body: some View {
        List {
            if error == RequestError.connectionError {
                Text("Verbindungsfehler")
            } else if error == RequestError.noStopsNearbyError {
                Text("Keine Haltestellen in der Nähe")
            } else if error == RequestError.noStopsFoundError {
                Text("Keine Haltestellen gefunden")
            } else if error == RequestError.noDeparturesError {
                Text("Keine Abfahrten verfügbar")
            } else if error == RequestError.noUpcomingStops {
                Text("Keine weiteren Haltestellen verfügbar")
            } else {
                Text("Fehler")
            }
        }
    }
}
