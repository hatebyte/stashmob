//
//  HalfContact.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

struct ReceivedItem {
    let placeId:String
    let phoneNumber:String?
    let email:String?
}

extension ReceivedItem {
    
    var options:Deliverable? {
        if let e = email, p = phoneNumber {
            return .Both(email:e, phoneNumber:p)
        } else if let e = email {
            return .Email(email:e)
        } else if let p = phoneNumber {
            return .Text(phoneNumber:p)
        }
        return nil
    }
    
}