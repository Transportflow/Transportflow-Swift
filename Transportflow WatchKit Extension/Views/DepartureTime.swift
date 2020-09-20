//
//  DepartureTime.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import SwiftUI

struct DepartureTime: View {
    var when: String
    @State var date: Date?
    @State var relativeMinutes: Int = 0
    
    let inputFormatter = DateFormatter()
    let outputFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            if date != nil {
                Text(relativeMinutes < 60 ? String(relativeMinutes) + "'" : String(relativeMinutes/60) + "h")
                Text(outputFormatter.string(from: date!))
                    .font(.caption)
                    .italic()
            } else {
                Text("--")
            }
        }.onAppear() {
            inputFormatter.dateFormat = "MMM dd, yyyy, hh:mm:ss a z"
            outputFormatter.dateFormat = "HH:mm"
            
            self.date = inputFormatter.date(from: when + " UTC")
            
            relativeMinutes = Int(date!.timeIntervalSinceNow/60)
            
            // Prettify
            if (relativeMinutes == -1) {
                relativeMinutes = 0
            }
        }
    }
}
