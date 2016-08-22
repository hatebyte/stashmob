//
//  UIApplication+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/22/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

extension UIApplication {
   
    public func navigateToSettings() {
        if #available(iOS 8.0, *) {
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            openURL(url!)
        }
    }
    
}
