//
//  AM.swift
//  CaptureMedia-Acme
//
//  Created by hatebyte on 9/24/14.
//  Copyright (c) 2014 capturemedia. All rights reserved.
//

import UIKit

extension UIView {
    
    class func fromNib<T:UIView>(nibNameOrNil:String? = nil) -> T {
        let v:T?                = fromNib(nibNameOrNil)
        return v!
    }
    
    class func fromNib<T:UIView>(nibNameOrNil:String? = nil) -> T? {
        var view:T?
        let name:String
        if let nibName = nibNameOrNil {
            name                = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name                = "\(T.self)".componentsSeparatedByString(".").last!
        }
        let nibViews            = NSBundle.mainBundle().loadNibNamed(name, owner:nil, options:nil)
        for v in nibViews {
            if let tog = v as? T {
                view            = tog
            }
        }
        return view
    }
}