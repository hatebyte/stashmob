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
   
    func remoteUserForPerson(person:ABRecordRef)->RemoteContact? {
        var number:String? = nil
        var email:String? = nil
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()
        if (ABMultiValueGetCount(emails) > 0) {
            let index = 0 as CFIndex
            email = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as? String
        }
        if let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            // TODO
            // YES I KNOW I SHOULD HANDLE WHICH NUMBER TO CHOOSE. BUT TIME IS A FACTOR
            for index in 0 ..< ABMultiValueGetCount(phoneNumbers) {
                number = ABMultiValueCopyValueAtIndex(phoneNumbers, index)?.takeRetainedValue() as? String
            }
            if let n = number {
                number = CMValidator.unFormatPhoneNumber(n)
            }
        }
        if email == nil && number == nil { return nil }
        
        var fName:String? = nil
        var lName:String? = nil
        let firstNameTemp = ABRecordCopyValue(person, kABPersonFirstNameProperty)
        if let fnt = firstNameTemp {
            let lfirstName: NSObject? = Unmanaged<NSObject>.fromOpaque(fnt.toOpaque()).takeRetainedValue()
            fName = lfirstName as? String
        }
        
        let lastNameTemp = ABRecordCopyValue(person, kABPersonLastNameProperty)
        if let lnt = lastNameTemp {
            let lastName: NSObject? = Unmanaged<NSObject>.fromOpaque(lnt.toOpaque()).takeRetainedValue()
            lName = lastName as? String
        }

        var rContact = RemoteContact(phoneNumber:number, email: email, firstName: fName, lastName: lName)
        if let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeUnretainedValue() {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                rContact.imageName = NSUUID().UUIDString
                rContact.saveRawImage(imgData)
            })
        }

        return rContact
    }

}