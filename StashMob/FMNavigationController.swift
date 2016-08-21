//
//  FMNavigationController.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import StashMobModel

class FMNavigationController: UINavigationController, ManagedObjectContextSettable, ManagedContactable {

    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!

    func accept(receivedItem:ReceivedItem) {
        if let predicate = Contact.contactForNumberOrEmailPredicate(receivedItem.email, phoneNumber: receivedItem.phoneNumber) {
            if let c = Contact.findOrFetchInContext(managedObjectContext, matchingPredicate: predicate) {
                let remoteContact = RemoteContact(managedContact: c)
                showReceivedModal(remoteContact, placeId: receivedItem.placeId)
                return
            }
        }
        ContactManager.getAccess { [unowned self] granted in
            if granted {
                if let remoteContact = self.contactManager.contactExistsForEmail(receivedItem.email, phoneNumber: receivedItem.phoneNumber) {
                    self.showReceivedModal(remoteContact, placeId: receivedItem.placeId)
                } else {
                    self.attemptToCreateContact(receivedItem)
                }
            }
        }
    }
    
    func showReceivedModal(remoteContact:RemoteContact, placeId:String) {
        let modalVC = UIStoryboard.receivedModal()
        modalVC.remoteContact           = remoteContact
        modalVC.placeId                 = placeId
        modalVC.placeRelation           = .Received
        modalVC.managedObjectContext    = managedObjectContext
        modalVC.shouldSave              = true
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func showLoginModal() {
        let modalVC = UIStoryboard.loginModal()
        modalVC.managedObjectContext    = managedObjectContext
        modalVC.contactManager          = contactManager
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func showCreateContactModal(receivedItem:ReceivedItem) {
        let modalVC = UIStoryboard.createContactModal()
        modalVC.managedObjectContext    = managedObjectContext
        modalVC.contactManager          = contactManager
        modalVC.receivedItem            = receivedItem
        modalVC.complete = { [weak self] remoteContact in
            if let rc = remoteContact {
                self?.showReceivedModal(rc, placeId: receivedItem.placeId)
            } else {
                self?.alertCreationDidntWork()
            }
        }
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func attemptToCreateContact(receivedItem:ReceivedItem) {
        var contactInfo:String      = ""
        let phoneNumber             = NSLocalizedString("number", comment: "CreateContact : alert : numberText")
        let email                   = NSLocalizedString("email", comment: "CreateContact : alert : emailText")
        switch receivedItem.options {
        case .Both(let e, let p):
            contactInfo = "\(email):\(e) or \(phoneNumber):\(p)"
        case .Email(let e):
            contactInfo = "\(email):\(e)"
        case .Text(let p):
            contactInfo = "\(phoneNumber):\(p)"
        }
        
        let alertTitle              = NSLocalizedString("New Contact!", comment: "CreateContact : alertTitle : text")
        let alertMessage            = NSLocalizedString("So it doesn't look like you don't have a contact for \(contactInfo). Would you like to create them so you can see the location?", comment: "CreateContact : alertmessage : text")
        
        let dismissText             = NSLocalizedString("Nah, forget it", comment: "CreateContact : no : titleText")
        let yesText            = NSLocalizedString("Oh hell yeah!", comment: "CreateContact : yes : titleText")
        
        
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction = UIAlertAction(title: dismissText, style: .Cancel)  { action in
        }
        let createAction = UIAlertAction(title: yesText, style: .Default)  { [weak self] action in
            self?.showCreateContactModal(receivedItem)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(createAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
  
    func alertCreationDidntWork() {
        let alertTitle              = NSLocalizedString("Well, I guess it didnt work. ", comment: "CreateContact : ErroralertTitle : text")
        let alertMessage            = NSLocalizedString("Whoops.", comment: "CreateContact : ErroralertTitle : message")
        
        let dismissText             = NSLocalizedString("Dismiss", comment: "CreateContact : Dismiss : titleText")
        
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction = UIAlertAction(title: dismissText, style: .Cancel)  { action in
        }
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
