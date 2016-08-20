//
//  Contactable.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import AddressBookUI



protocol Contactable:class {
    func remoteUserForPerson(person:ABRecordRef)->RemoteContact?
    
//    func contactExistsForKey(key:String)->RemoteContact?
//    func makeContactForKey(key:String)->RemoteContact
//    func makeContactForEmail(email:String)->RemoteContact
}

protocol ManagedContactable:class {
    weak var contactManager: Contactable! { get set }
}

