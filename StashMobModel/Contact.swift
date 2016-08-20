//
//  Contact.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData

public class Contact: ManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var email: String?
    @NSManaged var imageName: String?
    @NSManaged var sentPlaces: Set<Place>?
    @NSManaged var recievedPlaces: Set<Place>?

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
    
    public func addToSentPlaces(place:Place) {
        add(place, toSet:.SentPlaces)
    }
    
    public func addToRecievedPlaces(place:Place) {
        add(place, toSet: .RecievedPlaces)
    }
    
    private func add(place:Place, toSet:Keys) {
        let items = mutableSetValueForKey(toSet)
        items.addObject(place)
    }

    public static func contactForPhoneNumberPredicate(number:String)->NSPredicate {
        return NSPredicate(format: "%K == %@", Keys.PhoneNumber.rawValue, number)
    }
    
    public static func contactForEmailPredicate(email:String)->NSPredicate {
        return NSPredicate(format: "%K == %@", Keys.Email.rawValue, email)
    }
    
    public static func contactForNumberOrEmailPredicate(key:String)->NSPredicate {
        print(key)
        return NSPredicate(format: "%K == %@ OR %K == %@ ", Keys.PhoneNumber.rawValue, key, Keys.Email.rawValue, key)
    }
 
    
}

extension Contact : KeyCodable {
    public enum Keys : String {
        case SentPlaces         = "sentPlaces"
        case RecievedPlaces     = "recievedPlaces"
        case CreatedAt          = "createdAt"
        case PhoneNumber        = "phoneNumber"
        case Email              = "email"
    }
}

extension Contact : ManagedObjectType {
    public static var entityName:String { return "Contact" }
    public static var defaultSortDescriptors:[NSSortDescriptor] {
        return [NSSortDescriptor(key:Keys.CreatedAt.rawValue, ascending: false)]
    }
    public static var defaultPredicate:NSPredicate {
        return NSPredicate(value:true)
    }
}


extension RemoteContact : RemoteMappable {
    
    public func mapTo<T:ManagedObjectType>(managedObject:T) {
        guard let contact = managedObject as? Contact else {
            fatalError("Object mapped is not a Contact")
        }
        if contact.firstName == nil && contact.lastName == nil {
            contact.createdAt = NSDate()
        }
        
        contact.phoneNumber            = phoneNumber
        contact.firstName              = firstName ?? ""
        contact.lastName               = lastName ?? ""
        contact.email                  = email
        contact.imageName              = imageName
    }
    
}

extension RemoteContact {
    
    public func insertIntoContext(moc:NSManagedObjectContext)->Contact {
        var predicate: NSPredicate!
        if let n = phoneNumber {
           predicate = NSPredicate(format:"%K == %@", Contact.Keys.PhoneNumber.rawValue, n)
        } else if let n = email {
            predicate = NSPredicate(format:"%K == %@", Contact.Keys.Email.rawValue, n)
        } else {
            fatalError("The remote contact has neither email nor phone number")
        }
        return Contact.insertOrUpdate(moc, matchingPredicate : predicate) { contact in
            self.mapTo(contact)
        }
    }
    
}