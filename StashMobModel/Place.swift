//
//  Place.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData


public class Place: ManagedObject {

    @NSManaged public var placeId: String
    @NSManaged public var name: String?
    @NSManaged public var createdAt: NSDate
    @NSManaged public var lastVisited: NSDate
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var phoneNumber: String?
    @NSManaged public var priceLevel: Int16
    @NSManaged public var rating: Float
    @NSManaged public var status: Int16
    @NSManaged public var types: [String]?
    @NSManaged public var websiteUrlString: String?
    @NSManaged public var sentToContacts: Set<Contact>?
    @NSManaged public var receivedFromContacts: Set<Contact>?

    public func sendTo(contact:Contact) {
        contact.addToSentPlaces(self)
    }
    
    public func recievedFrom(contact:Contact) {
        contact.addToRecievedPlaces(self)
    }

    public static var allReceivedLocationsPredicate:NSPredicate {
        return NSPredicate(format: "ANY %K != NULL", Keys.ReceivedFromContacts.rawValue)
    }
    
    public static var allSentLocationsPredicate:NSPredicate {
        return NSPredicate(format: "ANY %K != NULL", Keys.SentToContacts.rawValue)
    }

    public static func placeForIdPredicate(placeId:String)->NSPredicate {
        return NSPredicate(format: "%K == %@", Keys.PlaceId.rawValue, placeId)
    }
    
}

extension Place : KeyCodable {
    public enum Keys : String {
        case CreatedAt = "createdAt"
        case PlaceId = "placeId"
        case ReceivedFromContacts = "receivedFromContacts"
        case SentToContacts = "sentToContacts"
    }
}

extension Place : ManagedObjectType {
    public static var entityName:String { return "Place" }
    public static var defaultSortDescriptors:[NSSortDescriptor] {
        return [NSSortDescriptor(key:Keys.CreatedAt.rawValue, ascending: false)]
    }
    public static var defaultPredicate:NSPredicate {
        return NSPredicate(value:true)
    }
}

extension Place : BinaryStringArrayTransformable {}







