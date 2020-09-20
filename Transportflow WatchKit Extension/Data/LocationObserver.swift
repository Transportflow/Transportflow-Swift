//
//  LocationObserver.swift
//
//  Created by Daisuke TONOSAKI on 2019/10/14.
//  Copyright © 2019 Daisuke TONOSAKI. All rights reserved.
//
import Foundation
import CoreLocation
import Combine

class LocationObserver: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var location = CLLocation()
    public let objectWillChange = PassthroughSubject<CLLocation,Never>()
  
    private let locationManager: CLLocationManager
  
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
    
        self.locationManager.delegate = self
    }
    
    func start() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
  
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        location = didUpdateLocations.last!
        self.objectWillChange.send(location)
    }
}
