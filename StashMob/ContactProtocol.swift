//
//  ContactProtocol.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel

protocol Contactable {
    func contactExistsForPhoneNumber(number:String)->RemoteContact?
    func makeContactForNumber(number:String, firstName:String, lastName:String, imageData:NSData?)->RemoteContact
}



/**
 
 let status = ABAddressBookGetAuthorizationStatus()
 if status == .Denied || status == .Restricted {
 println("Not authorized: Go to settings and authorize this app")
 return
 }
 
 var error: Unmanaged<CFError>?
 let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue()
 if addressBook == nil {
 println(error?.takeRetainedValue())
 return
 }
 
 ABAddressBookRequestAccessWithCompletion(addressBook) { granted, error in
 if !granted {
 println("Not authorized: Go to settings and authorize this app: \(error)")
 return
 }
 
 let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
 for person in people {
 let contactName = ABRecordCopyCompositeName(person)?.takeRetainedValue() as? String
 let contact = Contact(name: contactName)
 
 if let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
 for index in 0 ..< ABMultiValueGetCount(phoneNumbers) {
 let number = ABMultiValueCopyValueAtIndex(phoneNumbers, index)?.takeRetainedValue() as? String
 let label  = ABMultiValueCopyLabelAtIndex(phoneNumbers, index)?.takeRetainedValue()
 
 let phoneNumber = PhoneNumber(label: self.localizedLabel(label), number: number)
 contact.phoneNumbers.append(phoneNumber)
 }
 }
 
 self.contacts.append(contact)
 }
 }
 
 */