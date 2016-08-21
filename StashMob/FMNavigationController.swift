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
                print("Found in core data : \(remoteContact)")
                // show modal with contact and place id
                showReceivedModal(remoteContact, placeId: receivedItem.placeId)
                return
            }
        }

        if let remoteContact = contactManager.contactExistsForEmail(receivedItem.email, phoneNumber: receivedItem.phoneNumber) {
            print("Found in contacts : \(remoteContact)")
            // show modal with contact and place id
            showReceivedModal(remoteContact, placeId: receivedItem.placeId)
        } else {
            
            print("whoops, need to create contact : \(receivedItem)")
            
        }
    }
    
    func showReceivedModal(remoteContact:RemoteContact, placeId:String) {
        let modalVC = UIStoryboard.receivedModal()
        modalVC.remoteContact           = remoteContact
        modalVC.placeId                 = placeId
        modalVC.placeRelation           = .Received
        modalVC.managedObjectContext    = managedObjectContext
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func showLoginModal() {
        let modalVC = UIStoryboard.loginModal()
        modalVC.managedObjectContext    = managedObjectContext
        modalVC.contactManager          = contactManager
        presentViewController(modalVC, animated: true, completion: nil)
    }
    
}
