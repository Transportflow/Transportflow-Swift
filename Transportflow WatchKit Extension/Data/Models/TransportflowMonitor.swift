//
//  TransportflowMonitor.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation

struct TransportflowMonitor: Decodable {
    var stop: TransportflowStop
    var stopovers: [TransportflowStopover]
}
