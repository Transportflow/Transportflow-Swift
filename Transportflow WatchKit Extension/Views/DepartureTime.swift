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
                Text(formatMinutes(relativeMinutes, indicatePositive: false, longSpelling: false))
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

func formatMinutes(_ minutes: Int, indicatePositive: Bool, longSpelling: Bool) -> String {
    var output: String
    if longSpelling {
        output = minutes < 60 ? String(minutes) + " min" : String(minutes/60) + " h"
    } else {
        output = minutes < 60 ? String(minutes) + "'" : String(minutes/60) + "h"
    }
    
    if (minutes > -1 && indicatePositive) {
        output = "+" + output
    }
    
    return output
}
