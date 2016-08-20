//
//  PlaceAndContactFetchable.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import CoreData

protocol ManagedObjectContextSettable:class {
    weak var managedObjectContext: NSManagedObjectContext! { get set }
}

protocol ContactAndPlaceFetchable {
    func fetchAllContacts()->[RemoteContact]
    func fetchAllSentPlaces()->[RemotePlace]
    func fetchAllRecievedPlaces()->[RemotePlace]
    func receivedPlacesFrom(contact:RemoteContact)->[RemotePlace]
    func sentPlacesTo(contact:RemoteContact)->[RemotePlace]
    func contactsWhoSentMePlace(place:RemotePlace)->[RemoteContact]
    func contactsWhoWereSentPlace(place:RemotePlace)->[RemoteContact]
}

extension NSManagedObjectContext : ContactAndPlaceFetchable {
   
    func fetchAllContacts()->[RemoteContact] {
        let contacts = Contact.fetchInContext(self) { request in
            request.predicate = Contact.defaultPredicate
            request.fetchBatchSize = 100
            request.returnsObjectsAsFaults = false
        }
        return contacts.map { RemoteContact(managedContact:$0) }
    }
    
    func fetchAllSentPlaces()->[RemotePlace] {
        let places = Place.fetchInContext(self) { request in
            request.predicate = Place.allSentLocationsPredicate
            request.fetchBatchSize = 100
            request.returnsObjectsAsFaults = false
        }
        print(places)
        return places.map { RemotePlace(managedPlace:$0) }
    }
    
    func fetchAllRecievedPlaces()->[RemotePlace] {
        let contacts = Place.fetchInContext(self) { request in
            request.predicate = Place.allReceivedLocationsPredicate
            request.fetchBatchSize = 100
            request.returnsObjectsAsFaults = false
        }
        return contacts.map { RemotePlace(managedPlace:$0) }
    }
   
    private func contactForNumber(string:String)->Contact? {
        let predicate = Contact.contactForPhoneNumberPredicate(string)
        return Contact.findOrFetchInContext(self, matchingPredicate: predicate)
    }
    
    private func contactForEmail(string:String)->Contact? {
        let predicate = Contact.contactForEmailPredicate(string)
        return Contact.findOrFetchInContext(self, matchingPredicate: predicate)
    }

    private func contactForEmailOrNumber(rcontact:RemoteContact)->Contact? {
        var key:String!
        if let number = rcontact.phoneNumber {
            key = number
        } else if let email = rcontact.email {
            key = email
        }
        guard key != nil else {
            return nil
        }
        let predicate = Contact.contactForNumberOrEmailPredicate(key)
        return Contact.findOrFetchInContext(self, matchingPredicate: predicate)
    }
    
    func receivedPlacesFrom(rcontact:RemoteContact)->[RemotePlace] {
        guard let contact = contactForEmailOrNumber(rcontact) else {
            return []
        }
        return contact.recievedRemotePlaces
    }
    
    func sentPlacesTo(rcontact:RemoteContact)->[RemotePlace] {
        guard let contact = contactForEmailOrNumber(rcontact) else {
            return []
        }
        return contact.sentRemotePlaces
   }
    
    private func placeForId(placeid:String)->Place? {
        let predicate = Place.placeForIdPredicate(placeid)
        return Place.findOrFetchInContext(self, matchingPredicate: predicate)
    }
    
    func contactsWhoSentMePlace(place:RemotePlace)->[RemoteContact] {
        guard let place = placeForId(place.placeId) else {
            return []
        }
        return place.recievedFromRemoteContacts
    }
    
    func contactsWhoWereSentPlace(place:RemotePlace)->[RemoteContact] {
        guard let place = placeForId(place.placeId) else {
            return []
        }
        return place.sentToRemoteContacts
    }

}