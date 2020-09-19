//
//  ProviderSelection.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI
import Alamofire

struct TransportflowProvider: Decodable, Identifiable {
    let id: String
    let image: String
    let beta: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "regionName"
        case image = "image"
        case beta = "beta"
    }
}

struct ProviderSelection: View {
    @State var providers: [TransportflowProvider] = []
    @State var loading: Bool = true
    @State var providerName = UserDefaults.standard.string(forKey: "provider") ?? ""
    
    func getProviders() -> Void {
        AF.request("https://backend.transportflow.online/providers").responseDecodable(of: [TransportflowProvider].self) { response in
            do {
                providers = try response.result.get()
            } catch {
                debugPrint(error)
            }
            loading = false
        }
    }
    
    func setProvider(id: String) -> Void {
        debugPrint(id)
        providerName = id
        UserDefaults.standard.set(id, forKey: "provider")
    }
    
    var body: some View {
        VStack {
            if loading {
                Text("Loading")
            } else {
                List(providers) { provider in
                    Button(action: {setProvider(id: provider.id)}) {
                        Text(provider.id).fontWeight(providerName == provider.id ? Font.Weight.bold : Font.Weight.regular)
                    }
                }
            }
        }.onAppear(perform: {
            getProviders()
            
            // Reload active provider from UserDefaults
            providerName = UserDefaults.standard.string(forKey: "provider") ?? ""
        })
        .navigationTitle("Region")
    }
}

struct ProviderSelection_Previews: PreviewProvider {
    static var previews: some View {
        ProviderSelection()
    }
}
