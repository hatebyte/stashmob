//
//  User+Extension.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import CoreData

extension User {
    
    func deepLinkUrlMessage(placeId:String)->String {
        var emailhash = ""
        var phoneHash = ""
        var amp = ""
        if let e = email {
            emailhash = "e=\(e)"
        }
        if let pn = phoneNumber {
            phoneHash   = "n=\(pn)"
        }
        if phoneHash != "" && emailhash != "" {
            amp = "&"
        }
        return "\(subMessage)\n\n\(NSBundle.mainBundle().deepLinkUrl)://?p=\(placeId)&\(emailhash)\(amp)\(phoneHash)"
    }
    
    func emailInfo(placeId:String)->EmailInfo {
        guard let eml = email else { fatalError("User needs the email to create email info") }
        let info = EmailInfo(
            titleString: title
            ,messageString: deepLinkUrlMessage(placeId)
            ,toRecipentsArray:[eml]
        )
        return info
    }
    
    func textInfo(placeId:String)->TextInfo {
        guard let pn = phoneNumber else { fatalError("User needs the phone to create text info") }
        let info = TextInfo(
            messageString: deepLinkUrlMessage(placeId)
            ,toRecipentsArray:[pn]
        )
        return info
    }
    
    var options:Deliverable {
        if let _ = email, _ = phoneNumber {
            return .Both
        } else if let _ = email {
            return .Email
        } else if let _ = phoneNumber{
            return .Text
        }
        fatalError("The User needs something to contact you by")
    }

}