//
//  ContactPickerViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import AddressBookUI
import CoreData

class ContactPickerViewController: UIViewController, ManagedObjectContextSettable {
        
    weak var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        var error: Unmanaged<CFError>?
        let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue()
        if addressBook == nil {
            print(error?.takeRetainedValue())
            
            return
        }
        
        ABAddressBookRequestAccessWithCompletion(addressBook) { granted, error in
            if !granted {
                print("Not authorized: Go to settings and authorize this app: \(error)")
                return
            }
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func pop() {
    
    }

    //MARK: Alert error
    func showAlert(title:String, message:String? = nil) {
        let alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissText = NSLocalizedString("Dismiss", comment: "ContactPickerViewController : dismissButton : titleText")
        alertController.addAction(UIAlertAction(title: dismissText, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertController, animated: true) { [unowned self] in
            self.pop()
        }
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

extension ContactPickerViewController : ABPeoplePickerNavigationControllerDelegate {
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef) {
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue()
        if (ABMultiValueGetCount(emails) > 0) {
            let index = 0 as CFIndex
            let email = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as! String
            print("first email for selected contact = \(email)")
        } else {
            print("No email address")
        }
        if let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            for index in 0 ..< ABMultiValueGetCount(phoneNumbers) {
                let number = ABMultiValueCopyValueAtIndex(phoneNumbers, index)?.takeRetainedValue() as? String
                print("first number for selected contact = \(number)")
            }
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecordRef) -> Bool {
        
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        
        return false;
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }

}