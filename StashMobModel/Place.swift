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

    @NSManaged var placeId: String
    @NSManaged var name: String?
    @NSManaged var createdAt: NSDate
    @NSManaged var lastVisited: NSDate
    @NSManaged var address: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var phoneNumber: String?
    @NSManaged var priceLevel: Int16
    @NSManaged var rating: Float
    @NSManaged var status: Int16
    @NSManaged var types: [String]?
    @NSManaged var websiteUrlString: String?
    @NSManaged var sentToContacts: Set<Contact>?
    @NSManaged var receivedFromContacts: Set<Contact>?

    public func sendTo(contact:Contact) {
        contact.addToSentPlaces(self)
    }
    
    public func recievedFrom(contact:Contact) {
        contact.addToRecievedPlaces(self)
    }
    
    public var sentToRemoteContacts:[RemoteContact] {
        guard let sc = sentToContacts else { return [] }
        return contactsToRemoteContacts(sc)
    }
    
    public var recievedFromRemoteContacts:[RemoteContact] {
        guard let rc = receivedFromContacts else { return [] }
        return contactsToRemoteContacts(rc)
    }
    
    private func contactsToRemoteContacts(c:Set<Contact>)->[RemoteContact] {
        return NSSet(set:c).map { RemoteContact(managedContact:$0 as! Contact) }
    }

    public static var allReceivedLocationsPredicate:NSPredicate {
        return NSPredicate(format: "%K != NULL AND %K[SIZE] > 0", Keys.ReceivedFromContacts.rawValue, Keys.ReceivedFromContacts.rawValue)
    }
    
    public static var allSentLocationsPredicate:NSPredicate {
        return NSPredicate(format: "%K != NULL AND %K[SIZE] > 0", Keys.SentToContacts.rawValue, Keys.SentToContacts.rawValue)
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
