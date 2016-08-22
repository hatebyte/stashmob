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
    func contactExistsFor(email email:String?, phoneNumber:String?)->(contact:RemoteContact?, data:NSData?)
    func createContact(remoteContact:RemoteContact)->Bool
    static func getAccess(granted:(Bool)->())
}

protocol ManagedContactable:class {
    weak var contactManager: Contactable! { get set }
}

