//
//  CreateContactViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData

typealias FinisheCreation = (RemoteContact?)->()

class CreateContactViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable {
        
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    var receivedItem:ReceivedItem!
    var complete:FinisheCreation!
    
    var theView:CreateContactView {
        guard let v = view as? CreateContactView else { fatalError("The view is not a CreateContactView") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theView.didLoad()
        theView.populate(receivedItem)
        theView.phoneNumberTextField?.delegate      = self
        theView.emailTextField?.delegate            = self
        theView.firstNameTextField?.delegate        = self
        theView.lastNameTextField?.delegate         = self
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
        theView.submitButton?.addTarget(self, action: #selector(attempToCreateRemoteContact), forControlEvents: .TouchUpInside)
        let nc                                      = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector:#selector(areFieldsPopulated), name:UITextFieldTextDidChangeNotification,      object:nil)
    }
    
    func removeHandlers() {
        theView.submitButton?.removeTarget(self, action: #selector(attempToCreateRemoteContact), forControlEvents: .TouchUpInside)
        let nc                                      = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name:UITextFieldTextDidChangeNotification,          object:nil)
    }
   
    func areFieldsPopulated() {
        theView.submitButton?.enabled = false
        if isPhoneNumberValid || isEmailValid {
            if isFirstNameValid && isLastNameValid {
                theView.submitButton?.enabled = true
            }
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
    
    var isFirstNameValid:Bool {
        if let text = theView.firstNameTextField?.text {
            if text.characters.count >= 2 { return true }
        }
        return false
    }

    var isLastNameValid:Bool {
        if let text = theView.lastNameTextField?.text {
            if text.characters.count >= 2 { return true }
        }
        return false
    }

    func attempToCreateRemoteContact() {
        theView.phoneNumberTextField?.resignFirstResponder()
        theView.emailTextField?.resignFirstResponder()
        theView.firstNameTextField?.resignFirstResponder()
        theView.lastNameTextField?.resignFirstResponder()
        
        var unformatedPhone:String?
        if let text = theView.phoneNumberTextField?.text {
            unformatedPhone = CMValidator.unFormatPhoneNumber(text) as String
        }
 
        let tempContact = RemoteContact(
            phoneNumber     : unformatedPhone
            ,email          : theView.emailTextField?.text
            ,firstName      : theView.firstNameTextField?.text
            ,lastName       : theView.lastNameTextField?.text
        )
        print(tempContact)
        if contactManager.createContact(tempContact) == true {
            dismissViewControllerAnimated(true, completion: { [weak self] in
                self?.complete(tempContact)
            })
        } else {
            dismissViewControllerAnimated(true, completion: { [weak self] in
                self?.complete(nil)
            })
        }
    }
    
}

extension CreateContactViewController : UITextFieldDelegate {
    
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
