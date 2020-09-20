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
    case noStopsError
    case noDeparturesError
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
                failure(.noStopsError)
            } else {
                success(result)
            }
        } catch AFError.responseSerializationFailed {
            failure(.noStopsError)
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
        URLQueryItem(name: "duration", value: String(250))
    ]
    
    AF.request(components.url!).responseDecodable(of: TransportflowMonitor.self) { response in
        if case .failure(_) = response.result {
            debugPrint(response.result)
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
        } /*catch AFError.responseSerializationFailed {
            debugPrint(AFError.responseSerializationFailed)
            failure(.noDeparturesError)
        }*/ catch {
            debugPrint(error)
            failure(.connectionError)
        }
    }
}
