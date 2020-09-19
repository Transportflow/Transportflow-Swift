//
//  Monitor.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI

struct Monitor: View {
    @State var provider = UserDefaults.standard.string(forKey: "provider") ?? ""
    @State var stopSearch = ""
    
    var body: some View {
        VStack {
            TextField("Haltestelle", text: $stopSearch)
                .padding()
            
            Spacer()
        }.onAppear(perform: {
            // Reload active provider from UserDefaults
            provider = UserDefaults.standard.string(forKey: "provider") ?? ""
        })
        .navigationTitle("Monitor")
    }
}

struct Monitor_Previews: PreviewProvider {
    static var previews: some View {
        Monitor()
    }
}
