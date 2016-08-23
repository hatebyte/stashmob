//
//  ContacFetchTests.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
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
        let url = NSURL(string: "stashmob://?e=V6hsB88vA/eL+hsGEJMr3Qn9a656BYyVU8kIyQ3imq4=")!
        
        // when
        let phoneNumber = url.numberParam()
        
        // then
        XCTAssertNil(phoneNumber)
    }
    
    func testNSURLCanReturnPhoneNumber() {
        // given
//        let url = NSURL(string: "stashmob://?p=ChIJvacMBYu8w4kRd0iusOBPFmg&e=V6hsB88vA/eL+hsGEJMr3Qn9a656BYyVU8kIyQ3imq4=&n=DUYAbFYvcDvHQHaq6wICZQ==")!
        let url = NSURL(string: "stashmob://?p=ChIJvacMBYu8w4kRd0iusOBPFmg&e=V6hsB88vA/eL+hsGEJMr3Qn9a656BYyVU8kIyQ3imq4=&n=9085818600")!
        
        // when
        let phoneNumber = url.numberParam()
        
        // then
        XCTAssertEqual("9085818600", phoneNumber!)
    }
   
    
    func testNSURLCanReturnReturnsNullEmail() {
        // given
        let url = NSURL(string: "stashmob://?p=ChIJvacMBYu8w4kRd0iusOBPFmg&n=DUYAbFYvcDvHQHaq6wICZQ==")!
        
        // when
        let email = url.emailParam()
        
        // then
        XCTAssertNil(email)
    }
    
    func testNSURLCanReturnPhoneEmail() {
        // given
//        let url = NSURL(string: "stashmob://?p=ChIJvacMBYu8w4kRd0iusOBPFmg&e=V6hsB88vA/eL+hsGEJMr3Qn9a656BYyVU8kIyQ3imq4=&n=DUYAbFYvcDvHQHaq6wICZQ==")!
        let url = NSURL(string: "stashmob://?p=ChIJvacMBYu8w4kRd0iusOBPFmg&e=hatebyte@gmail.com&n=DUYAbFYvcDvHQHaq6wICZQ==")!
        
        // when
        let email = url.emailParam()
        
        // then
        XCTAssertEqual("hatebyte@gmail.com", email!)
    }
    
    
    
}
