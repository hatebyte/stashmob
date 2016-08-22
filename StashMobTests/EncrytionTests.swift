//
//  StashMobTests.swift
//  StashMobTests
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import XCTest
@testable import StashMob

class StashMobTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    func testCanDecryptHashedPhoneNumber() {
        // given
        let unhashed = "9085818600"
        let en = Crypter.encrypt(unhashed)

        // when
        let dn = Crypter.decrypt(en)
        
        // then 
        XCTAssertNotEqual(unhashed, en, "The unhashed phone number is not the same as the unhashed")
        XCTAssertEqual(unhashed, dn, "The dehashed phone number is the same as the unhashed")
    }
 
    func testUrlEncodeAndDecryptionOfEmailCanHappen() {
        // given
        let s = "hatebyte@gmail.com";
        let en = Crypter.encrypt(s)
 
        // when
        let sEncode = en.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
        
        // then
        let sDecode = sEncode?.stringByRemovingPercentEncoding
        let dn = Crypter.decrypt(sDecode!)
        
        XCTAssertEqual(s, dn)
    }
    
    
    func testUrlEncodeAndDecryptionOfNumberCanHappen() {
        // given
        let s = "9085818600";
        let en = Crypter.encrypt(s)
        
        // when
        let sEncode = en.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
        
        // then
        let sDecode = sEncode?.stringByRemovingPercentEncoding
        let dn = Crypter.decrypt(sDecode!)
        
        XCTAssertEqual(s, dn)
    }

    
}
