//
//  ContactManager.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import AddressBookUI

class ContactManager: Contactable {
 
    let addressBook: ABAddressBookRef?
    
    init() {
        var error: Unmanaged<CFError>?
        guard let add: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue() else {
            fatalError("WHOA, Big Contact problems out the door. No Address book")
        }
        self.addressBook = add
    }
    
    func remoteUserForPerson(person:ABRecordRef)->RemoteContact? {
        let email = quickEmail(person)
        var number = quickPhoneNumber(person)
        if let n = number {
            number = CMValidator.unFormatPhoneNumber(n)
        }

        if email == nil && number == nil { return nil }
        let fName = propForKey(person, key:kABPersonFirstNameProperty)
        let lName = propForKey(person, key:kABPersonLastNameProperty)
        var rContact = RemoteContact(phoneNumber:number, email: email, firstName: fName, lastName: lName)
        if let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeUnretainedValue() {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                rContact.imageName = NSUUID().UUIDString
                rContact.saveRawImage(imgData)
            })
        }
        return rContact
    }
    
    func contactExistsForEmail(email:String?, phoneNumber:String?)->RemoteContact? {
        let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as Array
        var record: ABRecordRef?
        for person in allContacts {
            let currentContact: ABRecordRef = person
            if let em = email {
                let e = quickEmail(person)
                if e == em {
                    record = currentContact
                    break
                }
            }
            if let num = phoneNumber {
                var number = quickPhoneNumber(person)
                if let n = number {
                    number = CMValidator.unFormatPhoneNumber(n)
                    if num == number {
                        record = currentContact
                        break
                    }
                }
            }
        }
        if let r = record {
            return remoteUserForPerson(r)
        } else {
            return nil
        }
    }

    func quickPhoneNumber(person:ABRecordRef)->String? {
        var number:String? = nil
        if let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            for index in 0 ..< ABMultiValueGetCount(phoneNumbers) {
                number = ABMultiValueCopyValueAtIndex(phoneNumbers, index)?.takeRetainedValue() as? String
            }
        }
        return number
    }
    
    func quickEmail(person:ABRecordRef)->String? {
        var email:String? = nil
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()
        if (ABMultiValueGetCount(emails) > 0) {
            let index = 0 as CFIndex
            email = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as? String
        }
        return email
    }

    func propForKey(person:ABRecordRef, key:ABPropertyID)->String? {
        let tempT = ABRecordCopyValue(person, key)
        if let fnt = tempT {
            let n: NSObject? = Unmanaged<NSObject>.fromOpaque(fnt.toOpaque()).takeRetainedValue()
            return n as? String
        }
        return nil
    }
    
}