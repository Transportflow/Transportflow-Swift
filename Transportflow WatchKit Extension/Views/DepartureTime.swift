//
//  DepartureTime.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import SwiftUI

var inputDateFormat = "MMM dd, yyyy, hh:mm:ss a z"

struct DepartureTime: View {
    var when: String
    var relativeCalculationDate: Date?
    var indicatePositive: Bool?
    @State var date: Date?
    @State var clockTime: String = ""
    @State var relativeMinutes: Int = 0
    
    let inputFormatter = DateFormatter()
    let outputFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            if date != nil {
                Text(formatMinutes(relativeMinutes, indicatePositive: indicatePositive ?? false, longSpelling: false))
                Text(clockTime)
                    .font(.caption)
                    .italic()
            } else {
                Text("--")
            }
        }.onAppear() {
            inputFormatter.dateFormat = inputDateFormat
            outputFormatter.dateFormat = "HH:mm"
            
            self.date = inputFormatter.date(from: when + " UTC")
            
            self.clockTime = outputFormatter.string(from: date!)
            self.relativeMinutes = getMinutes(fromDate: relativeCalculationDate ?? Date(), toDate: date!)
            
            // Prettify
            if (self.relativeMinutes == -1) {
                self.relativeMinutes = 0
            }
        }
    }
}

func getDateFromString(_ string: String?) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = inputDateFormat
    
    if string == nil {
        return nil;
    }
    
    return formatter.date(from: string! + " UTC")
}

func getMinutes(fromDate: Date, toDate: Date) -> Int {
    return Calendar.current.dateComponents([Calendar.Component.minute], from: fromDate, to: toDate).minute!
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
