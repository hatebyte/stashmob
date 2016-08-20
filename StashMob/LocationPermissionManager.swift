//
//  LocationPermissionManager.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreLocation

public protocol ApplicationRememberable {
    var hasBeenAskedForLocationInformation:Bool { get }
    func saveHasBeenAskedForLocationInformation()
}

public typealias Accepted = ()->()
public typealias Denied = ()->()

public class LocationPermissionsManager: NSObject {
    
    var accepted:Accepted!
    var denied:Denied!
    
    private weak var locationManager:UserLocationManager!
    
    public init(locationManager:UserLocationManager) {
        self.locationManager = locationManager
        super.init()
    }
    
    public func hasLocationSettingsTurnedOn()->Bool {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            return false
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted {
            return false
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            return false
        }
        return true
    }
    
    func askForLocationPermission() {
        locationManager?.startUpdating { [weak self] location in
            self?.locationManager?.stopUpdating()
        }
    }
    
    public func askForLocationPermission(accepted:Accepted, denied:Denied) {
        self.accepted                               = accepted
        self.denied                                 = denied

        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(locationSettingResponse), name:UIApplicationDidBecomeActiveNotification, object:nil)
        askForLocationPermission()
    }
    
    func locationSettingResponse() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIApplicationDidBecomeActiveNotification, object:nil)
        if self.hasLocationSettingsTurnedOn() {
            self.accepted()
        } else {
            self.denied()
        }
        self.accepted                               = nil
        self.denied                                 = nil
    }
}