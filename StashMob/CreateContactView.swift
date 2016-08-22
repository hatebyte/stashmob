//
//  CreateContactView.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

class CreateContactView: UIView {

    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var emailTextField:UITextField?
    @IBOutlet weak var phoneNumberTextField:UITextField?
    @IBOutlet weak var firstNameTextField:UITextField?
    @IBOutlet weak var lastNameTextField:UITextField?
    @IBOutlet weak var submitButton:UIButton?
    
    func didLoad() {
        let reasonText                          = NSLocalizedString("Complete contact's description until you can submit.\n(Phone number or email will do)", comment: "CreateContactView : reasonLabel : text")
        titleLabel?.text                        = reasonText
        titleLabel?.numberOfLines               = 0
        titleLabel?.adjustsFontSizeToFitWidth   = true
        
        
        let emailplaceholder                    = NSLocalizedString("email", comment: "CreateContactView : emailTextfield : placeholder")
        emailTextField?.placeholder             = emailplaceholder
        emailTextField?.adjustsFontSizeToFitWidth = true
        emailTextField?.font                    = UIFont.boldSystemFontOfSize(40)
        
        let numberplaceholder                   = NSLocalizedString("phone number", comment: "CreateContactView : phoneNumberTextField : placeholder")
        phoneNumberTextField?.placeholder       = numberplaceholder
        phoneNumberTextField?.adjustsFontSizeToFitWidth = true
        phoneNumberTextField?.font              = UIFont.boldSystemFontOfSize(40)
        
        let fnplaceholder                       = NSLocalizedString("first name", comment: "CreateContactView : firstNameTextField : placeholder")
        firstNameTextField?.placeholder         = fnplaceholder
        firstNameTextField?.adjustsFontSizeToFitWidth = true
        firstNameTextField?.font                = UIFont.boldSystemFontOfSize(40)
        
        let lnplaceholder                       = NSLocalizedString("last name", comment: "CreateContactView : phoneNumberTextField : placeholder")
        lastNameTextField?.placeholder          = lnplaceholder
        lastNameTextField?.adjustsFontSizeToFitWidth = true
        lastNameTextField?.font                 = UIFont.boldSystemFontOfSize(40)
        
        let submitText                          = NSLocalizedString("Create Contact", comment: "CreateContactView : submitButton : text")
        submitButton?.setTitle(submitText, forState: .Normal)
        submitButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton?.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        submitButton?.enabled                   = false
    }
    
    func populate(receivedItem:ReceivedItem) {
        switch receivedItem.options {
        case .Both(let e, let p):
            emailTextField?.text                = e
            phoneNumberTextField?.text          = p
        case .Email(let e):
            emailTextField?.text                = e
        case .Text(let p):
            phoneNumberTextField?.text          = p
        }
    }
    
}
