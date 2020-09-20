//
//  DepartureTime.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import SwiftUI

struct DepartureTime: View {
    var outputFormatter: DateFormatter
    var when: Date?
    
    var body: some View {
        VStack {
            if when != nil {
                let relativeMinutes = Int(when!.timeIntervalSinceNow/60)
                Text(relativeMinutes < 60 ? String(relativeMinutes) + "'" : String(relativeMinutes/60) + "h")
                Text(outputFormatter.string(from: when!))
                    .font(.caption)
                    .italic()
            } else {
                Text("---")
            }
        }
    }
}
