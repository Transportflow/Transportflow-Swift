//
//  TransportflowLocation.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation

struct TransportflowLocation: Decodable {
    var name: String?
    var address: String?
    var latitude: Double
    var longitude: Double
}

