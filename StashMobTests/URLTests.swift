//
//  ContacFetchTests.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
import StashMobModel
import CoreData
@testable import StashMob

class URLTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testNSURLCanReturnReturnsNullPlaceId() {
        // given
        let url = NSURL(string: "stashmob://?e=hashofemail&n=hashofphonenumber")!
        
        // when
        let placeId = url.placeParam()
        
        // then
        XCTAssertNil(placeId)
    }
    
    func testNSURLCanReturnPlaceId() {
        // given
        let url = NSURL(string: "stashmob://?p=asdfadsfdsa&e=hashofemail&n=hashofphonenumber")!
        
        // when
        let placeId = url.placeParam()
        
        // then
        XCTAssertEqual("asdfadsfdsa", placeId!)
    }

    func testNSURLCanReturnReturnsNullPhoneNumber() {
        // given
        let url = NSURL(string: "stashmob://?e=hashofemail")!
        
        // when
        let phoneNumber = url.numberParam()
        
        // then
        XCTAssertNil(phoneNumber)
    }
    
    func testNSURLCanReturnPhoneNumber() {
        // given
        let url = NSURL(string: "stashmob://?p=asdfadsfdsa&e=hashofemail&n=hashofphonenumber")!
        
        // when
        let phoneNumber = url.numberParam()
        
        // then
        XCTAssertEqual("hashofphonenumber", phoneNumber!)
    }
   
    
    func testNSURLCanReturnReturnsNullEmail() {
        // given
        let url = NSURL(string: "stashmob://?p=asdfadsfdsa&n=hashofphonenumber")!
        
        // when
        let email = url.emailParam()
        
        // then
        XCTAssertNil(email)
    }
    
    func testNSURLCanReturnPhoneEmail() {
        // given
        let url = NSURL(string: "stashmob://?p=asdfadsfdsa&e=hashofemail&n=hashofphonenumber")!
        
        // when
        let email = url.emailParam()
        
        // then
        XCTAssertEqual("hashofemail", email!)
    }
    
    
    
}
