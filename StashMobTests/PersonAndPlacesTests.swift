//
//  PersonAndPlacesTests.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
import StashMobModel
import CoreData
@testable import StashMob

class PersonAndPlacesTests: XCTestCase {
   
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
            remotePlace1.placeId = "30"
            var remotePlace2 = testPlace
            remotePlace2.name = "Zoo"
            remotePlace2.placeId = "31"
            
            let mrp1 = remotePlace1.insertIntoContext(self.moc)
            let mrp2 = remotePlace2.insertIntoContext(self.moc)
            mrp1.recievedFrom(mjake)
            mrp2.recievedFrom(mjake)
        }
        waitForManagedObjectContextToBeDone(moc)
    }
    
    func testUserCanReturnTupleOfPersonOrPlace() {
        // given
        let sally = RemoteContact(
            phoneNumber        : "9085818601"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Sally"
            ,lastName           : "Jones"
        )
        send2PlacesToRemoteUser(sally)
        recieve2PlacesFromRemoteUser(sally)
        
        // then
        var user:Contact!
        moc.performChanges{ [unowned self] in
            user = sally.insertIntoContext(self.moc)
        }
        waitForManagedObjectContextToBeDone(moc)
        
        let tupe = moc.sentAndReceivedFor(user)

        // then
        XCTAssertEqual(2, tupe.sent.places.count)
        XCTAssertEqual(2, tupe.received.places.count)
    }
    
    
    func testmapContactsToPersonAndPlaces() {
        // given
        let sally = RemoteContact(
            phoneNumber        : "9085818601"
            ,email              : "mylegfeelsfunn@gmail.com"
            ,firstName          : "Sally"
            ,lastName           : "Jones"
        )
        let ed = RemoteContact(
            phoneNumber        : "9085818600"
            ,email              : "mylegfeels@gmail.com"
            ,firstName          : "ed"
            ,lastName           : "Jones"
        )

        send2PlacesToRemoteUser(sally)
        recieve2PlacesFromRemoteUser(sally)
        send2PlacesToRemoteUser(ed)
        recieve2PlacesFromRemoteUser(ed)
 
        // then
        let pandp = moc.mapContactsToPersonAndPlaces()
        
        // then
        XCTAssertEqual(2, pandp.received.count)
        let first = pandp.received.first!
        XCTAssertEqual(2, first.places.count)
        
        XCTAssertEqual(2, pandp.sent.count)
    }
    
}
