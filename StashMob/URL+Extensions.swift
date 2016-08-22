//
//  URL+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

import UIKit


enum UrlParam : String {
    case PhoneNumber     = "n"
    case Email           = "e"
    case PlaceId         = "p"
}

enum ParamValues {
    case KeyFound(value:String)
    case NoKey
}

typealias ParamFor = (key:UrlParam)->ParamValues

extension NSURL {
   
    var receivedItem:ReceivedItem? {
        guard let p = placeParam() else {
            return nil
        }
        let n = numberParam()
        let e = emailParam()
        return ReceivedItem(placeId: p, phoneNumber:n, email: e)
    }
    
    var paramFor:ParamFor {
        get {
//            if #available(iOS 8, *) {
                return self.paramForIOS8
//            } else {
//                return self.paramForIOS7
//            }
        }
    }
    
    func placeParam()->String? {
        let e = self.paramFor(key:.PlaceId)
        switch e {
        case ParamValues.KeyFound(let value):
            return value
        case ParamValues.NoKey:
            return nil
        }
    }
    
    func emailParam()->String? {
        let e = self.paramFor(key:.Email)
        switch e {
        case ParamValues.KeyFound(let value):
            if let v = value.stringByRemovingPercentEncoding {
                return Crypter.decrypt(v)
            } else {
                return nil
            }
        case ParamValues.NoKey:
            return nil
        }
    }
    
    func numberParam()->String? {
        let e = self.paramFor(key:.PhoneNumber)
        switch e {
        case ParamValues.KeyFound(let value):
            if let v = value.stringByRemovingPercentEncoding {
                return Crypter.decrypt(v)
            } else {
                return nil
            }
        case ParamValues.NoKey:
            return nil
        }
    }
    
    @available(iOS 8, *)
    func paramForIOS8(key:UrlParam)->ParamValues {
        if let urlComponents        = NSURLComponents(URL:self, resolvingAgainstBaseURL:true) {
            if let items = urlComponents.queryItems {
                for item in items {
                    if item.name == key.rawValue {
                        return .KeyFound(value:item.value!)
                    }
                }
            }
        }
        return .NoKey
    }
    
    @available(iOS 7, *)
    func paramForIOS7(key:UrlParam)->ParamValues {
        if let paramString = self.query {
            let pairs = paramString.componentsSeparatedByString("&") as [String]
            for pair in pairs  {
                let pairComp = pair.componentsSeparatedByString("=") as [String]
                let k = pairComp.first?.stringByRemovingPercentEncoding
                if k == key.rawValue {
                    let value = pairComp.last?.stringByRemovingPercentEncoding
                    return .KeyFound(value:value!)
                }
            }
        }
        return .NoKey
    }
    
}