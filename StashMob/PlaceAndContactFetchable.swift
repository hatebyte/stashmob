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
    
    func receivedPlacesFrom(rcontact:RemoteContact)->[RemotePlace] {
        if let number = rcontact.phoneNumber {
            guard let contact = contactForNumber(number) else {
                return []
            }
            return contact.recievedRemotePlaces
        }
        if let email = rcontact.email {
            guard let contact = contactForEmail(email) else {
                return []
            }
            return contact.recievedRemotePlaces
        }
        return []
    }
    
    func sentPlacesTo(rcontact:RemoteContact)->[RemotePlace] {
        if let number = rcontact.phoneNumber {
            guard let contact = contactForNumber(number) else {
                return []
            }
            return contact.sentRemotePlaces
        }
        if let email = rcontact.email {
            guard let contact = contactForEmail(email) else {
                return []
            }
            return contact.sentRemotePlaces
        }
        return []
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