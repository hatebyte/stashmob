//
//  RemotePlace.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import CoreData

public struct RemotePlace {
    
    public var placeId: String
    public var name: String?
    public var address: String?
    public var latitude: Double
    public var longitude: Double
    public var phoneNumber: String?
    public var priceLevel: Int?
    public var rating: Float
    public var status: Int
    public var types: [String]
    public var websiteUrlString: String?
 
    public init(
        placeId: String
        ,name: String?
        ,address: String?
        ,latitude: Double
        ,longitude: Double
        ,phoneNumber: String?
        ,priceLevel: Int?
        ,rating: Float
        ,status:Int
        ,types:[String]
        ,websiteUrlString: String?
        ) {
        self.placeId                = placeId
        self.name                   = name
        self.address                = address
        self.latitude               = latitude
        self.longitude              = longitude
        self.phoneNumber            = phoneNumber
        self.priceLevel             = priceLevel
        self.rating                 = rating
        self.status                 = status
        self.types                  = types
        self.websiteUrlString       = websiteUrlString
    }
    
}

extension RemotePlace {
    
    public init(managedPlace : Place ){
        self.placeId                = managedPlace.placeId
        self.name                   = managedPlace.name
        self.address                = managedPlace.address
        self.latitude               = managedPlace.latitude
        self.longitude              = managedPlace.longitude
        self.phoneNumber            = managedPlace.phoneNumber
        self.priceLevel             = Int(managedPlace.priceLevel)
        self.rating                 = managedPlace.rating
        self.status                 = Int(managedPlace.status)
        self.types                  = managedPlace.types ?? []
        self.websiteUrlString       = managedPlace.websiteUrlString
    }
    
}





extension RemotePlace : RemoteMappable {
    
    public func mapTo<T:ManagedObjectType>(managedObject:T) {
        guard let place = managedObject as? Place else {
            fatalError("Object mapped is not a Place")
        }
        if place.longitude == 0 && place.latitude == 0 {
            place.createdAt = NSDate()
        }
        place.lastVisited = NSDate()
        
        place.placeId                = placeId
        place.name                   = name
        place.address                = address
        place.latitude               = latitude
        place.longitude              = longitude
        place.phoneNumber            = phoneNumber
        place.priceLevel             = Int16(priceLevel ?? 0)
        place.rating                 = rating
        place.status                 = Int16(status)
        place.types                  = types
        place.websiteUrlString       = websiteUrlString
    }
    
}

extension RemotePlace {
    
    public func insertIntoContext(moc:NSManagedObjectContext)->Place {
        let predicate = NSPredicate(format:"%K == %@", Place.Keys.PlaceId.rawValue, placeId)
        return Place.insertOrUpdate(moc, matchingPredicate : predicate) { place in
            self.mapTo(place)
        }
    }
    
}