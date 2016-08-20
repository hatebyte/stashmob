//
//  StashMobModelTests.swift
//  StashMobModelTests
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
import CoreData
@testable import StashMobModel

class PlaceModelTests: XCTestCase {

    var moc:NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()

        moc = NSManagedObjectContext.inMemoryContext()
    }
    
    override func tearDown() {
        moc = nil
        super.tearDown()
    }
    
    func testCanConvertRemotePlaceIntoCoreDataPlace() {
        // given
        let remotePlace             = testPlace
        
        // when
        let mRemotePlace            = remotePlace.insertIntoContext(moc)
        waitForManagedObjectContextToBeDone(moc)
   
        // then
        XCTAssertEqual("place_id_def", mRemotePlace.placeId)
        XCTAssertEqual("Malrooneys Park", mRemotePlace.name)
        XCTAssertEqual("122 Buttercup Lane", mRemotePlace.address)
        XCTAssertEqual(47.0, mRemotePlace.latitude)
        XCTAssertEqual(74.0, mRemotePlace.longitude)
        XCTAssertEqual("9085818600", mRemotePlace.phoneNumber)
        XCTAssertEqual(12, mRemotePlace.priceLevel)
        XCTAssertEqual(3, mRemotePlace.status)
        XCTAssertEqual(["nice", "smelly"], mRemotePlace.types!)
        XCTAssertEqual("https://reddit.com/r/swift", mRemotePlace.websiteUrlString!)
    }

}
