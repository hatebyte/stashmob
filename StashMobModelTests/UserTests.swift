//
//  UserTests.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
import CoreData
@testable import StashMobModel

class UserTests: XCTestCase {
    
    var moc:NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        moc = NSManagedObjectContext.inMemoryContext()
    }
    
    override func tearDown() {
        moc = nil
        super.tearDown()
    }
    
    func testThereIsNoLoggedInUser() {
        // given
        moc.performChanges { [unowned self] in
            let user:User = self.moc.insertObject()
            user.phoneNumber = "9085818600"
            user.firstName = "Scott"
            user.lastName = "Jones"
        }
        waitForManagedObjectContextToBeDone(moc)
        
        // when
        let loginUser = User.loggedInUser(moc)
        
        // then
        XCTAssertNil(loginUser)
    }

    func testCanLoginUser() {
        // given
        let user:User = self.moc.insertObject()
        moc.performChanges {
            user.phoneNumber = "9085818600"
            user.firstName = "Scott"
            user.lastName = "Jones"
        }
        waitForManagedObjectContextToBeDone(moc)

        // then
        moc.performChanges {
            user.setAsLoggedInUser()
        }
        waitForManagedObjectContextToBeDone(moc)
        
        // then
        let loginUser = User.loggedInUser(moc)
        XCTAssertNotNil(loginUser)
    }
    
}
