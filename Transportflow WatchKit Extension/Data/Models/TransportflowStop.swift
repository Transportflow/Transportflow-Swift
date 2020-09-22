//
//  TransportflowStop.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation

struct TransportflowStop: Decodable, Identifiable {
    var id: String
    var name: String
    var location: TransportflowLocation
    var products: [TransportflowProduct]?
    var distance: Double?
}
