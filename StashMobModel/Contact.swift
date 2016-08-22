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

    @NSManaged public var createdAt: NSDate
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var imageName: String?
    @NSManaged public var sentPlaces: Set<Place>?
    @NSManaged public var recievedPlaces: Set<Place>?

    public var hasImage:Bool {
        return imageName != nil
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

    public static var allReceivedContactsPredicate:NSPredicate {
        return NSPredicate(format: "ANY %K != NULL", Keys.RecievedPlaces.rawValue)
    }
    
    public static var allSentContactsPredicate:NSPredicate {
        return NSPredicate(format: "ANY %K != NULL", Keys.SentPlaces.rawValue)
    }
    
    public static func contactForPhoneNumberPredicate(number:String)->NSPredicate {
        return NSPredicate(format: "%K == %@", Keys.PhoneNumber.rawValue, number)
    }
    
    public static func contactForEmailPredicate(email:String)->NSPredicate {
        return NSPredicate(format: "%K == %@", Keys.Email.rawValue, email)
    }
    
    public static func contactForNumberOrEmailPredicate(key:String)->NSPredicate {
        return NSPredicate(format: "%K == %@ OR %K == %@ ", Keys.PhoneNumber.rawValue, key, Keys.Email.rawValue, key)
    }

    public static func contactForNumberOrEmailPredicate(email:String?, phoneNumber:String?)->NSPredicate? {
        if let e = email {
            guard let p = phoneNumber else {
                return contactForEmailPredicate(e)
            }
            return NSPredicate(format: "%K == %@ OR %K == %@ ", Keys.PhoneNumber.rawValue, e, Keys.Email.rawValue, p)
        }
        if let p = phoneNumber {
            return contactForPhoneNumberPredicate(p)
        }
        return nil
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
