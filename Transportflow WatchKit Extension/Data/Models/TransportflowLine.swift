//
//  TransportflowLine.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation

struct TransportflowLine: Decodable {
    var name: String
    var fahrtNr: String?
    var mode: String
    var product: TransportflowProduct
}
