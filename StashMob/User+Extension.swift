//
//  User+Extension.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    func deepLinkUrlMessage(placeId:String)->String {
        var emailhash = ""
        var phoneHash = ""
        var amp = ""
        if let e = email {
            let en = Crypter.encrypt(e)
            emailhash = "e=\(en.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!)"
        }
        if let pn = phoneNumber {
            let en = Crypter.encrypt(pn)
            phoneHash   = "n=\(en.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!)"
        }
        if phoneHash != "" && emailhash != "" {
            amp = "&"
        }
        return "\(subMessage)\n\n\(NSBundle.mainBundle().deepLinkUrl)://?p=\(placeId)&\(emailhash)\(amp)\(phoneHash)"
    }
    
    func emailInfo(placeId:String, email em:String)->EmailInfo {
        let info = EmailInfo(
            titleString: title
            ,messageString: deepLinkUrlMessage(placeId)
            ,toRecipentsArray:[em]
        )
        return info
    }
    
    func textInfo(placeId:String, phoneNumber pn:String)->TextInfo {
        let info = TextInfo(
            messageString: deepLinkUrlMessage(placeId)
            ,toRecipentsArray:[pn]
        )
        return info
    }
    
    var options:Deliverable {
        if let e = email, p = phoneNumber {
            return .Both(email:e, phoneNumber:p)
        } else if let e = email {
            return .Email(email:e)
        } else if let p = phoneNumber {
            return .Text(phoneNumber:p)
        }
        fatalError("The User needs something to contact you by")
    }

}