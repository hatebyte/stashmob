//
//  ContactModel.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
import CoreData
@testable import StashMobModel

class ContactModel: XCTestCase {

    var moc:NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        moc = NSManagedObjectContext.inMemoryContext()
    }
    
    override func tearDown() {
        moc = nil
        super.tearDown()
    }
    
    func testCanConvertRemoteContactIntoCoreDataContact() {
        // given
        let remoteContact             = testContact
        
        // when
        let mRemoteContact            = remoteContact.insertIntoContext(moc)
        waitForManagedObjectContextToBeDone(moc)
 
        // then
        XCTAssertEqual("9085818600", mRemoteContact.phoneNumber)
        XCTAssertEqual("Scott", mRemoteContact.firstName!)
        XCTAssertEqual("Jones", mRemoteContact.lastName!)
    }
    
    func testPlaceCanBeSavedAsSentToContact() {
        // given
        let remoteContact             = testContact
        let mRemoteContact            = remoteContact.insertIntoContext(moc)
        
        // when
        let remotePlace             = testPlace
        let mRemotePlace            = remotePlace.insertIntoContext(moc)
        waitForManagedObjectContextToBeDone(moc)
        
        moc.performChanges {
            mRemoteContact.addToSentPlaces(mRemotePlace)
        }
        waitForManagedObjectContextToBeDone(moc)
        
        // then
        XCTAssertEqual(mRemoteContact.sentPlaces!.count, 1)
    }
    
    func testPlaceCanBeSavedAsReceievedFromContact() {
        // given
        let remoteContact             = testContact
        let mRemoteContact            = remoteContact.insertIntoContext(moc)
        
        // when
        let remotePlace             = testPlace
        let mRemotePlace            = remotePlace.insertIntoContext(moc)
        waitForManagedObjectContextToBeDone(moc)
        
        moc.performChanges {
            mRemoteContact.addToRecievedPlaces(mRemotePlace)
        }
        waitForManagedObjectContextToBeDone(moc)
        
        // then
        XCTAssertEqual(mRemoteContact.recievedPlaces!.count, 1)
    }
   
    func testPlaceCanBeSavedAsReceievedFromContactButNotDuplicated() {
        // given
        let remoteContact             = testContact
        let mRemoteContact            = remoteContact.insertIntoContext(moc)
        
        // when
        let remotePlace             = testPlace
        let mRemotePlace            = remotePlace.insertIntoContext(moc)
        waitForManagedObjectContextToBeDone(moc)
        
        moc.performChanges {
            for _ in 0..<10 {
                mRemoteContact.addToRecievedPlaces(mRemotePlace)
            }
        }
        waitForManagedObjectContextToBeDone(moc)
        
        // then
        let place = mRemoteContact.recievedRemotePlaces.first!
        XCTAssertEqual(place.name, "Malrooneys Park")
    }

    
    
}
