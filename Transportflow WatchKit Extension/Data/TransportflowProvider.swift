//
//  TransportflowProvider.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation

struct TransportflowProvider: Decodable, Identifiable {
    let id: String
    let region: String
    let provider: String
    let image: String
    let beta: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "regionName"
        case region = "region"
        case provider = "provider"
        case image = "image"
        case beta = "beta"
    }
}
