//
//  ContactManager.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

import AddressBookUI

class ContactManager: Contactable {
 
    var addressBook: ABAddressBookRef?
    
    init() {
        var error: Unmanaged<CFError>?
        let add: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue()
        self.addressBook = add
    }
   
    static func getAccess(grantedAccess:(Bool)->()) {
        var error: Unmanaged<CFError>?
        guard let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue() else {
            grantedAccess(false)
            return
        }
        ABAddressBookRequestAccessWithCompletion(addressBook) { granted, error in
            dispatch_async(dispatch_get_main_queue()) {
                if granted {
                    grantedAccess(true)
                } else {
                    grantedAccess(false)
                }
            }
        }
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
        return RemoteContact(phoneNumber:number, email: email, firstName: fName, lastName: lName)
    }
    
    func contactExistsFor(email email:String?, phoneNumber:String?)->(contact:RemoteContact?, data:NSData?) {
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
            if let imgData = ABPersonCopyImageDataWithFormat(r, kABPersonImageFormatThumbnail)?.takeUnretainedValue() {
                return (remoteUserForPerson(r), imgData)
            } else {
                return (remoteUserForPerson(r), nil)
            }
        } else {
            return (nil, nil)
        }
    }

    func createContact(remoteContact:RemoteContact)->Bool {
        let record: ABRecordRef = ABPersonCreate().takeRetainedValue()
        if let f = remoteContact.firstName {
            ABRecordSetValue(record, kABPersonFirstNameProperty, f, nil)
        }
        if let l = remoteContact.lastName {
            ABRecordSetValue(record, kABPersonLastNameProperty, l, nil)
        }
        if let e = remoteContact.email {
            let email: ABMultiValueRef = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
            ABMultiValueAddValueAndLabel(email, e, kABHomeLabel, nil)
            ABRecordSetValue(record, kABPersonEmailProperty, email, nil)
        }
        if let p = remoteContact.phoneNumber {
            let phoneNumbers: ABMutableMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
            ABMultiValueAddValueAndLabel(phoneNumbers, p, kABPersonPhoneMainLabel, nil)
            ABRecordSetValue(record, kABPersonPhoneProperty, phoneNumbers, nil)
        }
        
        ABAddressBookAddRecord(addressBook, record, nil)
        return saveAddressBookChanges()
    }
    
    func saveAddressBookChanges()->Bool {
        if ABAddressBookHasUnsavedChanges(addressBook){
            var err: Unmanaged<CFErrorRef>? = nil
            let savedToAddressBook = ABAddressBookSave(addressBook, &err)
            if savedToAddressBook {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    private func quickPhoneNumber(person:ABRecordRef)->String? {
        var number:String? = nil
        if let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            for index in 0 ..< ABMultiValueGetCount(phoneNumbers) {
                number = ABMultiValueCopyValueAtIndex(phoneNumbers, index)?.takeRetainedValue() as? String
            }
        }
        return number
    }
    
    private func quickEmail(person:ABRecordRef)->String? {
        var email:String? = nil
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()
        if (ABMultiValueGetCount(emails) > 0) {
            let index = 0 as CFIndex
            email = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as? String
        }
        return email
    }

    private func propForKey(person:ABRecordRef, key:ABPropertyID)->String? {
        let tempT = ABRecordCopyValue(person, key)
        if let fnt = tempT {
            let n: NSObject? = Unmanaged<NSObject>.fromOpaque(fnt.toOpaque()).takeRetainedValue()
            return n as? String
        }
        return nil
    }
    
}