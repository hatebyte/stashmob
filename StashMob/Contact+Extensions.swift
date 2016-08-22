//
//  Contact+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/22/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData


extension Contact {
    
    public var sentRemotePlaces:[RemotePlace] {
        guard let sp = sentPlaces else { return [] }
        return placesToRemotePlaces(sp)
    }
    
    public var recievedRemotePlaces:[RemotePlace] {
        guard let rp = recievedPlaces else { return [] }
        return placesToRemotePlaces(rp)
    }
    
    private func placesToRemotePlaces(ps:Set<Place>)->[RemotePlace] {
        return NSSet(set: ps).map { RemotePlace(managedPlace:$0 as! Place) }
    }
    
}