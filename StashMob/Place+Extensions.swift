//
//  Place+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/22/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData
import StashMobModel

extension Place {

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
    
 
}
