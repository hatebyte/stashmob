//
//  RemoteContact.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import CoreData

public struct RemoteContact {
    
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var email: String?
    public var imageName:String?
    
    public init(phoneNumber: String?, email:String?, firstName: String?, lastName: String?, imageName:String? = nil) {
        self.phoneNumber    = phoneNumber
        self.firstName      = firstName
        self.lastName       = lastName
        self.email          = email
        self.imageName      = imageName
    }
    
}

extension RemoteContact {
    
    public init(managedContact : Contact ){
        self.phoneNumber    = managedContact.phoneNumber
        self.firstName      = managedContact.firstName
        self.lastName       = managedContact.lastName
        self.email          = managedContact.email
        self.imageName      = managedContact.imageName
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