//
//  TransportflowStopover.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation

struct TransportflowStopover: Decodable, Identifiable {
    var id: String
    var direction: String
    var line: TransportflowLine
    var cancelled: Bool?
    var when: String
    var plannedWhen: String?
    var scheduledWhen: String?
    var rawWhen: String?
    var delay: Double
    var platform: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "tripId"
        case direction
        case line
        case cancelled
        case when
        case plannedWhen
        case scheduledWhen
        case rawWhen
        case delay
        case platform
    }
}

extension TransportflowStopover {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //id = id + direction + line.name + when
        let tripId = try values.decode(String.self, forKey: .id)
        direction  = try values.decode(String.self, forKey: .direction)
        when       = try values.decode(String.self, forKey: .when)
        
        id = tripId + direction + when
        line = try values.decode(TransportflowLine.self, forKey: .line)
        cancelled = try values.decodeIfPresent(Bool.self, forKey: .cancelled)
        plannedWhen = try values.decodeIfPresent(String.self, forKey: .plannedWhen)
        scheduledWhen = try values.decodeIfPresent(String.self, forKey: .scheduledWhen)
        rawWhen = try values.decodeIfPresent(String.self, forKey: .rawWhen)
        delay = try values.decode(Double.self, forKey: .delay)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
    }
}
