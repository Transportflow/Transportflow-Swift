//
//  ContentView.swift
//  Transportflow
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI

struct ContentView: View {
    @State var providerName = UserDefaults.standard.string(forKey: "provider") ?? ""
    @State var providers: [TransportflowProvider] = []
    
    var body: some View {
        Form {
            Section {
                Text("Hello")
                //NavigationLink("🚇 Monitor", destination: Monitor(provider: providerName))
                Picker(selection: $providerName, label: Text("🗺 Region wählen"), content: {
                    ForEach(providers) { provider in
                        Text(provider.region).tag(provider.region)
                    }
                }).onChange(of: self.providerName, perform: { newValue in
                    UserDefaults.standard.set(newValue, forKey: "provider")
                })
            }
        }.onAppear(perform: {
            if providers.isEmpty {
                getProviders(success: { result in
                    providers = result
                }, failure: { error in
                    debugPrint(error)
                })
            }
        })
        .navigationTitle("Transportflow")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
