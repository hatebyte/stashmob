//
//  Crypt.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
//import CryptoSwift

//extension String {
//    
//    func aesEncrypt(key: String, iv: String) throws -> String{
//        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
//        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes())
//        let encData = NSData(bytes: enc, length: Int(enc.count))
//        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
//        let result = String(base64String)
//        return result
//    }
//    
//    func aesDecrypt(key: String, iv: String) throws -> String? {
//        if let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0)) {
//            let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data.arrayOfBytes())
//            let decData = NSData(bytes: dec, length: Int(dec.count))
//            let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
//            return String(result!)
//        }
//        return nil
//    }
//
//}
//
//class Crypter {
//    
//    private static let key = "bbC2H19lkVbQDfakxcrtNMQdd0FloLyw" // length == 32
//    private static let iv = "gqLOHUioQ0QjhuvI" // length == 16
//    
//    static func encrypt(string:String)->String {
//        do {
//            let enc = try string.aesEncrypt(key, iv: iv)
//            return enc
//        } catch {
//            fatalError("CryptoSwift no longer works")
//        }
//    }
//    
//    static func decrypt(hash:String)->String? {
//        do {
//            if let dec = try hash.aesDecrypt(key, iv: iv) {
//                return dec
//            }
//            return nil
//        } catch {
//            return nil
//        }
//    }
//    
//}
