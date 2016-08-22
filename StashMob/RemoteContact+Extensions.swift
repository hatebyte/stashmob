//
//  RemoteContact.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

let title = NSLocalizedString("YO! Check out this wacky place!", comment: "Email Title : text")
let subMessage = NSLocalizedString("Follow this link to see what I'm up to.\n(Make sure you have StashMob on your phone.)", comment: "RemoteContact message : text")

enum  Deliverable {
    case Both(email:String, phoneNumber:String)
    case Email(email:String)
    case Text(phoneNumber:String)
}

extension RemoteContact {
    
    func saveImage(data:NSData) {
        guard let imgN = imageName else { return }
        NSFileManager.defaultManager().saveImageNamed(imgN, ext:"jpg", data:data)
        let tempImage                       = UIImage.circleImage(data)
        let pictureData                     = UIImagePNGRepresentation(tempImage)!
        NSFileManager.defaultManager().savePinImageNamed(imgN, ext:"png", data:pictureData)
    }
    
    func getImage()->UIImage {
        guard let imgN = imageName else { return UIImage(named: "defaultavatar")! }
        guard let img = NSFileManager.defaultManager().getImageNamed(imgN, ext:"jpg") else {
            return UIImage(named: "defaultavatar")!
        }
        return img
    }
    
    func getPinImage()->UIImage {
        guard let imgN = imageName else { return UIImage(named: "defaultavatar_pin")! }
        guard let img = NSFileManager.defaultManager().getPinImageNamed(imgN, ext:"png") else {
            return UIImage(named: "defaultavatar_pin")!
        }
        return img
    }
   
    var fullName:String {
        if let f = firstName, l = lastName {
            return "\(f) \(l)"
        } else if let f = firstName {
            return f
        } else if let l = lastName {
            return l
        }
        return ""
    }
    
    var options:Deliverable {
        if let e = email, p = phoneNumber {
            return .Both(email:e, phoneNumber:p)
        } else if let e = email {
            return .Email(email:e)
        } else if let p = phoneNumber {
            return .Text(phoneNumber:p)
        }
        fatalError("The RemoteContact has defied the logic of the app")
    }
    
}