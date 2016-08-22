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

    func checkLoggedIn() {
        if !isLoggedIn {
            showLoginModal()
        }
    }
    
    var isLoggedIn:Bool {
        return User.loggedInUser(managedObjectContext) != nil
    }
    
    func accept(receivedItem:ReceivedItem) {
        guard isLoggedIn else { return }
        if let predicate = Contact.contactForNumberOrEmailPredicate(receivedItem.email, phoneNumber: receivedItem.phoneNumber) {
            if let c = Contact.findOrFetchInContext(managedObjectContext, matchingPredicate: predicate) {
                let remoteContact = RemoteContact(managedContact: c)
                showReceivedModal(remoteContact, placeId: receivedItem.placeId)
                return
            }
        }
        ContactManager.getAccess { [unowned self] granted in
            if granted {
                let result = self.contactManager.contactExistsFor(email:receivedItem.email,
                    phoneNumber:receivedItem.phoneNumber)
                if var remoteContact = result.contact {
                    self.managedObjectContext.saveImageDataIfNecessary(&remoteContact, imageData: result.data)
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
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            self?.presentViewController(modalVC, animated: true, completion: nil)
        }
    }
    
    func showLoginModal() {
        let modalVC = UIStoryboard.loginModal()
        modalVC.managedObjectContext    = managedObjectContext
        modalVC.contactManager          = contactManager
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            self?.presentViewController(modalVC, animated: true, completion: nil)
        }
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
        guard let options =  receivedItem.options else {
            stopIt()
            return
        }
        switch options {
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
    
    func stopIt() {
        let alertTitle              = NSLocalizedString("Stop it", comment: "CreateContact : stopitalertTitle : title")
        let alertMessage            = NSLocalizedString("Don't edit the urls.", comment: "CreateContact : stopitalertTitle : message")
        
        let dismissText             = NSLocalizedString("I'm Sorry", comment: "CreateContact : stopitalertTitle : button")
        
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction = UIAlertAction(title: dismissText, style: .Cancel)  { action in
        }
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
