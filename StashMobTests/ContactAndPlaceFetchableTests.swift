//
//  ContactAndPlaceFetchableTests.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
import CoreData
@testable import StashMob

class ContactAndPlaceFetchableTests: XCTestCase {
    
    var moc:NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        moc = NSManagedObjectContext.inMemoryContext()
    }
    
    override func tearDown() {
        moc = nil
        super.tearDown()
    }
    
    func send2PlacesToRemoteUser(remoteUser:RemoteContact) {
        moc.performChanges { [unowned self] in
            let mjake = remoteUser.insertIntoContext(self.moc)
            var remotePlace1 = testPlace
            remotePlace1.name = "Barn yard"
            remotePlace1.placeId = "34"
            var remotePlace2 = testPlace
            remotePlace2.name = "Zoo"
            remotePlace2.placeId = "35"
            let mrp1 = remotePlace1.insertIntoContext(self.moc)
            let mrp2 = remotePlace2.insertIntoContext(self.moc)
            mrp1.sendTo(mjake)
            mrp2.sendTo(mjake)
        }
        waitForManagedObjectContextToBeDone(moc)
    }
    
    func recieve2PlacesFromRemoteUser(remoteUser:RemoteContact) {
        moc.performChanges { [unowned self] in
            let mjake = remoteUser.insertIntoContext(self.moc)
            var remotePlace1 = testPlace
            remotePlace1.name = "Barn yard"
            remotePlace1.placeId = "34"
            var remotePlace2 = testPlace
            remotePlace2.name = "Zoo"
            remotePlace2.placeId = "35"
            
            let mrp1 = remotePlace1.insertIntoContext(self.moc)
            let mrp2 = remotePlace2.insertIntoContext(self.moc)
            mrp1.recievedFrom(mjake)
            mrp2.recievedFrom(mjake)
        }
        waitForManagedObjectContextToBeDone(moc)
    }

    func sendPlaceToJakeAndSally(remotePlace:RemotePlace) {
        let jake = RemoteContact(
            phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunney@gmail.com"
            ,firstName          : "Jake"
            ,lastName           : "Jones"

        )
        let sally = RemoteContact(
            phoneNumber        : "9085818601"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Sally"
            ,lastName           : "Jones"
        )
        moc.performChanges { [unowned self] in
            let mjake = jake.insertIntoContext(self.moc)
            let msally = sally.insertIntoContext(self.moc)
            let mrp1 = remotePlace.insertIntoContext(self.moc)
            mrp1.sendTo(mjake)
            mrp1.sendTo(msally)
        }
        waitForManagedObjectContextToBeDone(moc)
    }
   
    func jakeAndSallySendPlaceToMe(remotePlace:RemotePlace) {
        let jake = RemoteContact(
            phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunney@gmail.com"
            ,firstName          : "Jake"
            ,lastName           : "Jones"
        )
        let sally = RemoteContact(
            phoneNumber        : "9085818601"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Sally"
            ,lastName           : "Jones"
        )
        moc.performChanges { [unowned self] in
            let mjake = jake.insertIntoContext(self.moc)
            let msally = sally.insertIntoContext(self.moc)
            let mrp1 = remotePlace.insertIntoContext(self.moc)
            mrp1.recievedFrom(mjake)
            mrp1.recievedFrom(msally)
        }
        waitForManagedObjectContextToBeDone(moc)
    }
    
    func testCanFetchAllRemoteContacts() {
        // given
        let remoteContact1 = RemoteContact(
             phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunn1@gmail.com"
            ,firstName          : "Larry"
            ,lastName           : "Jones"
        )
        let remoteContact2 = RemoteContact(
            phoneNumber        : "9085818601"
            ,email              : "mylegfeelsfun2@gmail.com"
            ,firstName          : "Scott"
            ,lastName           : "Jones"
        )
        let remoteContact3 = RemoteContact(
            phoneNumber        : "9085818602"
            ,email              : "mylegfeelsfunn3@gmail.com"
            ,firstName          : "Steve"
            ,lastName           : "Jones"
        )
        moc.performChanges { [unowned self] in
            remoteContact1.insertIntoContext(self.moc)
            remoteContact2.insertIntoContext(self.moc)
            remoteContact3.insertIntoContext(self.moc)
        }
        waitForManagedObjectContextToBeDone(moc)
        
        // when
        let contacts = moc.fetchAllContacts()
        
        //save them
        XCTAssertEqual(3, contacts.count)
    }

    func testCanFetchAllRemoteLocationsSentToMe() {
        // given
        let remoteContact1 = RemoteContact(
            phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Larry"
            ,lastName           : "Jones"
        )
        let remoteContact2 = RemoteContact(
            phoneNumber        : "9085818601"
            ,email              : "mylegfeelsfunn2@gmail.com"
            ,firstName          : "Scott"
            ,lastName           : "Jones"
        )
        moc.performChanges { [unowned self] in
            let rc1 = remoteContact1.insertIntoContext(self.moc)
            let rc2 = remoteContact2.insertIntoContext(self.moc)
            var remotePlace1 = testPlace
            remotePlace1.name = "Barn yard"
            remotePlace1.placeId = "34"
            var remotePlace2 = testPlace
            remotePlace2.name = "Zoo"
            remotePlace2.placeId = "35"
            let mrp1 = remotePlace1.insertIntoContext(self.moc)
            let mrp2 = remotePlace2.insertIntoContext(self.moc)
            mrp1.recievedFrom(rc1)
            mrp2.recievedFrom(rc2)
        }
        waitForManagedObjectContextToBeDone(moc)
 
        
        // when
        let contacts = moc.fetchAllRecievedPlaces()
        
        //save them
        XCTAssertEqual(2, contacts.count)
    }
    
    func testCanFetchAllRemoteLocationsSent() {
        // given
        let jake = RemoteContact(
             phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Jake"
            ,lastName           : "Jones"
        )
        send2PlacesToRemoteUser(jake)
        recieve2PlacesFromRemoteUser(jake)
        
        // when
        let contacts = moc.fetchAllSentPlaces()
        
        //save them
        XCTAssertEqual(2, contacts.count)
    }
    
    func testCanFetchAllRecievedPlacesFromRemoteContact() {
        // given
        let jake = RemoteContact(
             phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Jake"
            ,lastName           : "Jones"
        )
        recieve2PlacesFromRemoteUser(jake)
        send2PlacesToRemoteUser(jake)

        // when
        let places = moc.receivedPlacesFrom(jake)
        
        // then
        XCTAssertEqual(2, places.count)
    }
    
    func testCanFetchAllPlacesSentToRemoteContact() {
        // given
        let jake = RemoteContact(
             phoneNumber        : "9085818600"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Jake"
            ,lastName           : "Jones"
        )
        send2PlacesToRemoteUser(jake)
        
        // when
        let places = moc.sentPlacesTo(jake)
        
        // then
        XCTAssertEqual(2, places.count)
    }
    
    func testContactsWhoWereSentPlace() {
        // given
        var barnyard = testPlace
        barnyard.name = "Barn yard"
        barnyard.placeId = "34"

        sendPlaceToJakeAndSally(barnyard)
 
        // when
        let contacts = moc.contactsWhoWereSentPlace(barnyard)

        // then
        XCTAssertEqual(2, contacts.count)
    }
    
    func testContactsWhoSentPlace() {
        // given
        var barnyard = testPlace
        barnyard.name = "Barn yard"
        barnyard.placeId = "34"
        
        jakeAndSallySendPlaceToMe(barnyard)
        
        // when
        let contacts = moc.contactsWhoSentMePlace(barnyard)
        
        // then
        XCTAssertEqual(2, contacts.count)
    }
    
}
