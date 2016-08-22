//
//  UserLocationManager.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

public typealias UpdateLocation = (location:CLLocationCoordinate2D)->()

public class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    var update:UpdateLocation?
 
//    public class var shared :UserLocationManager {
//        struct Singleton {
//            static let instance = UserLocationManager()
//        }
//        return Singleton.instance
//    }
    
    lazy var locationManager: CLLocationManager! = {
        let manager                     = CLLocationManager()
        manager.desiredAccuracy         = kCLLocationAccuracyBest
        manager.delegate                = self
        if #available(iOS 8.0, *) {
            manager.requestWhenInUseAuthorization()
        }
        return manager
    }()
    
    public func startUpdating(update:UpdateLocation) {
        self.update                     = update;
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter  = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdating() {
        locationManager.stopUpdatingLocation()
        update                          = nil
    }
    
    public func updateLocation(newLocation:CLLocation) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            // test the age of the location measurement to determine if the measurement is cached
            // in most cases you will not want to rely on cached measurements
            let eventDate               = newLocation.timestamp;
            let locationAge             = eventDate.timeIntervalSinceNow
            if locationAge > 5.0 {
                return
            }
            // test that the horizontal accuracy does not indicate an invalid measurement
            if newLocation.horizontalAccuracy < 0 {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                self.update?(location: CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude))
            });
        })
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.updateLocation(newLocation)
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.updateLocation(location)
        }
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    
}

