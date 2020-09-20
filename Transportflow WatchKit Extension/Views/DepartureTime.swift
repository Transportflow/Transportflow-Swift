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
    @State var clockTime: String = ""
    @State var relativeMinutes: Int = 0
    
    let inputFormatter = DateFormatter()
    let outputFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            if date != nil {
                Text(relativeMinutes < 60 ? String(relativeMinutes) + "'" : String(relativeMinutes/60) + "h")
                Text(clockTime)
                    .font(.caption)
                    .italic()
            } else {
                Text("--")
            }
        }.onAppear() {
            inputFormatter.dateFormat = "MMM dd, yyyy, hh:mm:ss a z"
            outputFormatter.dateFormat = "HH:mm"
            
            self.date = inputFormatter.date(from: when + " UTC")
            
            self.clockTime = outputFormatter.string(from: date!)
            self.relativeMinutes = Int(date!.timeIntervalSinceNow/60)
            
            // Prettify
            if (self.relativeMinutes == -1) {
                self.relativeMinutes = 0
            }
        }
    }
}
