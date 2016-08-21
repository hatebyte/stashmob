//
//  UIApplication+Exentsion.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

extension UIApplication {

    public func navigateToSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        openURL(url!)
    }
   
    public func text(smsMessage:String) {
        openURL(NSURL(string:smsMessage)!)
    }
    
}