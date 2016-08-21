//
//  LoginView.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

class LoginView: UIView {

    @IBOutlet weak var emailTextField:UITextField?
    @IBOutlet weak var phoneNumberTextField:UITextField?
    @IBOutlet weak var orLabel:UILabel?
    @IBOutlet weak var reasonLabel:UILabel?
    @IBOutlet weak var submitButton:UIButton?
    
    func didLoad() {
        let reasonText                          = NSLocalizedString("Ok, I know this looks weird. But I need to log you in with either your phone number or email. This way when you send people places, I can identify you on the other side.", comment: "LoginView : reasonLabel : text")
        reasonLabel?.text                       = reasonText
        reasonLabel?.numberOfLines              = 0
        reasonLabel?.adjustsFontSizeToFitWidth  = true
        
        let orText                              = NSLocalizedString("or", comment: "LoginView : orLabel : text")
        orLabel?.text                           = orText
        
        let emailplaceholder                    = NSLocalizedString("email", comment: "LoginView : emailTextfield : placeholder")
        emailTextField?.placeholder             = emailplaceholder
        emailTextField?.adjustsFontSizeToFitWidth = true
        emailTextField?.font                    = UIFont.boldSystemFontOfSize(40)
       
        let numberplaceholder                   = NSLocalizedString("phone number", comment: "LoginView : phoneNumberTextField : placeholder")
        phoneNumberTextField?.placeholder       = numberplaceholder
        phoneNumberTextField?.adjustsFontSizeToFitWidth = true
        phoneNumberTextField?.font              = UIFont.boldSystemFontOfSize(40)
       
        let submitText                          = NSLocalizedString("Submit", comment: "LoginView : submitButton : placeholder")
        submitButton?.setTitle(submitText, forState: .Normal)
        submitButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton?.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        submitButton?.enabled                   = false
    }
 
}
