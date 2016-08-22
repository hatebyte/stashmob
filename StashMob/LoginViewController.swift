//
//  LoginViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable {
    
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    var theView:LoginView {
        guard let v = view as? LoginView else { fatalError("The view is not a LoginView") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theView.didLoad()
        theView.phoneNumberTextField?.delegate   = self
        theView.emailTextField?.delegate   = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addHandlers()

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeHandlers()
    }
    
    func addHandlers() {
        theView.submitButton?.addTarget(self, action: #selector(submitData), forControlEvents: .TouchUpInside)
        let nc                                      = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector:#selector(areFieldsPopulated), name:UITextFieldTextDidChangeNotification,      object:nil)
    }
    
    func removeHandlers() {
        theView.submitButton?.removeTarget(self, action: #selector(submitData), forControlEvents: .TouchUpInside)
        let nc                                      = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name:UITextFieldTextDidChangeNotification,          object:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Notification
    func areFieldsPopulated() {
        theView.submitButton?.enabled = false
        if isPhoneNumberValid {
            theView.submitButton?.enabled = true
            return
        }
        if isEmailValid {
            theView.submitButton?.enabled = true
        }
    }
    
    var isEmailValid:Bool {
        if let text = theView.emailTextField?.text {
            let validString = CMValidator.isEmailValid(text) as String
            return VALID_INPUT == validString
        }
        return false
    }
    
    var isPhoneNumberValid:Bool {
        if let text = theView.phoneNumberTextField?.text {
            let validString = CMValidator.validatePhoneNumber(CMValidator.unFormatPhoneNumber(text)) as String
                return VALID_INPUT == validString
        }
        return false
    }
    
    // MARK: Button handler
    func submitData() {
        theView.phoneNumberTextField?.resignFirstResponder()
        theView.emailTextField?.resignFirstResponder()
        
        let emailIsValid            = isEmailValid
        let phoneIsValid            = isPhoneNumberValid
       
        let user:User               = managedObjectContext.insertObject()
        managedObjectContext.performChangesAndWait { [unowned self] in
            let phoneNumber         = CMValidator.unFormatPhoneNumber(self.theView.phoneNumberTextField?.text)
            let email               = self.theView.emailTextField?.text

            if emailIsValid && phoneIsValid {
                user.phoneNumber    = phoneNumber
                user.email          = email
            } else if emailIsValid {
                user.email          = email
            } else {
                user.phoneNumber    = phoneNumber
            }
        }
        managedObjectContext.performChanges {
            user.setAsLoggedInUser()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController : UITextFieldDelegate {
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField == theView.phoneNumberTextField) {
            let returnOrValue:AnyObject!                = CMValidator.formatPhoneNumber(textField.text, withRange:range)
            if returnOrValue as? NSString == REACHED_MAX_LENGTH {
                return false;
            } else {
                textField.text                          = returnOrValue as? String
                return true
            }
        }
        return true
    }
    
}


