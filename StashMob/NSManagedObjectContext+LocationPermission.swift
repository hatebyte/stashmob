//
//  NSManagedObjectContext+LocationPermission.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData

public let AcceptedLocationPermissionsKey     = "com.hatebyte.stashmob.ios.locationtrakcing.key"
extension NSManagedObjectContext:ApplicationRememberable {
    
    public var hasBeenAskedForLocationInformation:Bool {
        guard let val = metaData[AcceptedLocationPermissionsKey] as? Bool else {
            return false
        }
        return val
    }
    
    public func saveHasBeenAskedForLocationInformation() {
        setMetaData(true, key:AcceptedLocationPermissionsKey)
    }
    
}