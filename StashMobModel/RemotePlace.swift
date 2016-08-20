//
//  RemotePlace.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

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