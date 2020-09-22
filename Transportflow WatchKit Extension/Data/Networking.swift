//
//  Networking.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 20.09.20.
//

import Foundation
import Alamofire
import CoreLocation

enum RequestError: Error {
    case `nil`
    case connectionError
    case noStopsFoundError
    case noStopsNearbyError
    case noDeparturesError
    case noUpcomingStops
}

func getProviders(success: @escaping([TransportflowProvider]) -> Void, failure: @escaping(Error) -> Void) -> Void {
    AF.request("https://backend.transportflow.online/providers").responseDecodable(of: [TransportflowProvider].self) { response in
        do {
            success(try response.result.get())
        } catch {
            failure(error)
        }
    }
}

func getStops(query: String, provider: String, success: @escaping([TransportflowStop]) -> Void, failure: @escaping(RequestError) -> Void) -> Void {
    var components = URLComponents()
        components.scheme = "https"
        components.host = "backend.transportflow.online"
        components.path = "/\(provider)/locations"
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
    
    AF.request(components.url!).responseDecodable(of: [TransportflowStop].self) { response in
        if case .failure(_) = response.result {
            failure(.connectionError)
            return
        }
        
        do {
            let result = try response.result.get()
            if result.isEmpty {
                failure(.noStopsFoundError)
            } else {
                success(result)
            }
        } catch AFError.responseSerializationFailed {
            failure(.noStopsFoundError)
        } catch {
            debugPrint(error)
            failure(.connectionError)
        }
    }
}

func getNearbyStops(location: CLLocation, provider: String, success: @escaping([TransportflowStop]) -> Void, failure: @escaping(RequestError) -> Void) -> Void {
    var components = URLComponents()
        components.scheme = "https"
        components.host = "backend.transportflow.online"
        components.path = "/\(provider)/nearby"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "lng", value: String(location.coordinate.longitude))
        ]
    
    AF.request(components.url!).responseDecodable(of: [TransportflowStop].self) { response in
        if case .failure(_) = response.result {
            failure(.connectionError)
            return
        }
        
        do {
            let result = try response.result.get()
            if result.isEmpty {
                failure(.noStopsNearbyError)
            } else {
                success(result)
            }
        } catch AFError.responseSerializationFailed {
            failure(.noStopsNearbyError)
        } catch {
            debugPrint(error)
            failure(.connectionError)
        }
    }
}

func getDepartures(stop: TransportflowStop, provider: String, success: @escaping(TransportflowMonitor) -> Void, failure: @escaping(RequestError) -> Void) -> Void {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "backend.transportflow.online"
    components.path = "/\(provider)/departures/\(stop.id)"
    components.queryItems = [
        URLQueryItem(name: "when", value: String(Int(NSDate().timeIntervalSince1970))),
        URLQueryItem(name: "duration", value: String(80))
    ]
    
    AF.request(components.url!).responseDecodable(of: TransportflowMonitor.self) { response in
        if case .failure(_) = response.result {
            failure(.connectionError)
            return
        }
        
        do {
            let result = try response.result.get()
            if result.stopovers.isEmpty {
                failure(.noDeparturesError)
            } else {
                success(result)
            }
        } catch AFError.responseSerializationFailed {
            failure(.noDeparturesError)
        } catch {
            failure(.connectionError)
        }
    }
}

func getUpcomingStops(stop: TransportflowStop, stopover: TransportflowStopover, provider: String, success: @escaping([TransportflowUpcomingStop]) -> Void, failure: @escaping(RequestError) -> Void) -> Void {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "backend.transportflow.online"
    components.path = "/\(provider)/upcoming/\(stopover.tripId)"
    components.queryItems = [
        URLQueryItem(name: "currentstopid", value: stop.id),
        URLQueryItem(name: "linename", value: stopover.line.name),
        URLQueryItem(name: "when", value: stopover.rawWhen != nil ? stopover.rawWhen : "0"),
        URLQueryItem(name: "relativeto", value: stopover.when)
    ]
    
    AF.request(components.url!).responseDecodable(of: [TransportflowUpcomingStop].self) { response in
        if case .failure(_) = response.result {
            failure(.connectionError)
            return
        }
        
        do {
            let result = try response.result.get()
            if result.isEmpty {
                failure(.noUpcomingStops)
            } else {
                success(result)
            }
        } catch AFError.responseSerializationFailed {
            failure(.noUpcomingStops)
        } catch {
            failure(.connectionError)
        }
    }
}
