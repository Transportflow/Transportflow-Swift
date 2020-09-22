//
//  TransportflowUpcomingStop.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 22.09.20.
//

import Foundation

struct TransportflowUpcomingStop: Identifiable, Decodable {
    var id: String
    
    var stop: TransportflowStop
    
    var departure: String?
    var departureDelay: Double?
    
    var arrival: String?
    var arrivalDelay: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case stop
        
        case departure
        case departureDelay
        
        case arrival
        case arrivalDelay
    }
}

extension TransportflowUpcomingStop {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //id = id + direction + line.name + when
        stop = try values.decode(TransportflowStop.self, forKey: .stop)
        
        departure      = try values.decodeIfPresent(String.self, forKey: .departure)
        departureDelay = try values.decodeIfPresent(Double.self, forKey: .departureDelay)
        
        arrival      = try values.decodeIfPresent(String.self, forKey: .arrival)
        arrivalDelay = try values.decodeIfPresent(Double.self, forKey: .arrivalDelay)
        
        id = stop.id + (departure != nil ? departure! : arrival != nil ? arrival! : "")
    }
}
