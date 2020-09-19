//
//  Monitor.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI
import Alamofire

struct TransportflowStop: Decodable, Identifiable {
    var id: String
    var name: String
    var location: TransportflowLocation
    var distance: Double?
}

struct TransportflowLocation: Decodable {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

struct Monitor: View {
    @ObservedObject var locationObserver = LocationObserver()
    @State var provider = UserDefaults.standard.string(forKey: "provider") ?? ""
    @State var nearbyStops: [TransportflowStop] = []
    @State var loading = true
    @State var stopSearch = ""
    
    func getNearbyStops() -> Void {
        let coord = locationObserver.location.coordinate
        loading = true
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "backend.transportflow.online"
            components.path = "/\(provider)/nearby"
            components.queryItems = [
                URLQueryItem(name: "lat", value: String(coord.latitude)),
                URLQueryItem(name: "lng", value: String(coord.longitude))
            ]
        
        AF.request(components.url!).responseDecodable(of: [TransportflowStop].self) { response in
            do {
                nearbyStops = try response.result.get()
                debugPrint(nearbyStops)
            } catch {
                debugPrint(error)
            }
            loading = false
        }
    }
    
    var body: some View {
        VStack {
            TextField("Haltestelle", text: $stopSearch)
            List(nearbyStops) { stop in
                Text(stop.name)
            }
        }.onAppear(perform: {
            // Reload active provider from UserDefaults
            provider = UserDefaults.standard.string(forKey: "provider") ?? ""
            
            getNearbyStops()
        })
        .navigationTitle("Monitor")
    }
}

struct Monitor_Previews: PreviewProvider {
    static var previews: some View {
        Monitor()
    }
}
