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
import StashMobModel

class ContactPickerViewController: UIViewController, ManagedObjectContextSettable {
        
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    private var gmController:GMCenteredController!
    var remotePlace:RemotePlace!
    var remoteContact:RemoteContact!
    var emailDelegate:EmailDelegate?
    var textDelegate:TextDelegate?
    
    var theView:ContactPickerView {
        guard let v = view as? ContactPickerView else { fatalError("The view is not a ContactPickerView") }
        return v
    }
    
    deinit {
        gmController = nil
        emailDelegate = nil
        textDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theView.didload()
        theView.populatePlace(remotePlace)
        gmController                = GMCenteredController(mapView: theView.mapView!, coordinate:remotePlace.coordinate, image: UIImage(named:"event_pin"))
        
        let picker                  = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties  = [NSNumber(int: kABPersonPhoneProperty)]
        
        var error: Unmanaged<CFError>?
        guard let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue() else {
            self.showNoSettingsAlert()
            return
        }
        ABAddressBookRequestAccessWithCompletion(addressBook) { [unowned self] granted, error in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                if granted {
                    self.presentViewController(picker, animated:false, completion: nil)
                } else {
                    self.showNoSettingsAlert()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if #available(iOS 8.3, *) {
            managedObjectContext.refreshAllObjects()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        theView.sendButton?.addTarget(self, action: #selector(send), forControlEvents: .TouchUpInside)
        theView.dontSendButton?.addTarget(self, action: #selector(pop), forControlEvents: .TouchUpInside)
    }
    
    func removeHandlers() {
        theView.sendButton?.removeTarget(self, action: #selector(send), forControlEvents: .TouchUpInside)
        theView.dontSendButton?.removeTarget(self, action: #selector(pop), forControlEvents: .TouchUpInside)
    }
    
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }

    func send() {
        guard let loggedInUser = User.loggedInUser(managedObjectContext) else {
            fatalError("FIX THIS, THE USER ISNT EVEN LOGGED IN")
        }

        switch remoteContact.options {
        case .Both(let email, let phoneNumber):
            let titleText = NSLocalizedString("How do you want to message \(remoteContact.fullName)", comment: "ContactPickerViewController : actionSheetTitle : titleText")

            let actionController = UIAlertController(title:titleText, message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let emailText = NSLocalizedString("EMAIL", comment: "ContactPickerViewController : actionSheet : emailButton")
            let textText = NSLocalizedString("TEXT", comment: "ContactPickerViewController : actionSheet : textButton")

            let emailAction = UIAlertAction(title: emailText, style: .Default)  { [unowned self] action in
                let einfo = loggedInUser.emailInfo(self.remotePlace.placeId, email:email)
                self.sendEmail(einfo)
            }
            let textAction = UIAlertAction(title: textText, style: .Default)  { [unowned self] action in
                let tinfo = loggedInUser.textInfo(self.remotePlace.placeId, phoneNumber:phoneNumber)
                self.sendTextMessage(tinfo)
            }
            actionController.addAction(emailAction)
            actionController.addAction(textAction)
            presentViewController(actionController, animated: true, completion: nil)

        case .Email(let email):
            let einfo = loggedInUser.emailInfo(remotePlace.placeId, email:email)
            sendEmail(einfo)
        case .Text(let phoneNumber):
            let tinfo = loggedInUser.textInfo(remotePlace.placeId, phoneNumber:phoneNumber)
            sendTextMessage(tinfo)
        }
    }
    
    //MARK: Alert error
    func showAlert(title:String, message:String? = nil, block:()->()) {
        let alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissText = NSLocalizedString("Dismiss", comment: "ContactPickerViewController : dismissButton : titleText")
        alertController.addAction(UIAlertAction(title: dismissText, style: .Default) { action in
                block()
        })
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showNoSettingsAlert(){
        let alertMessage            = NSLocalizedString("Well Hmm, we do need permission to your Contacts to get this done.", comment: "ContactPickerViewController : alertTile : noAddresBook")
        let dismissText             = NSLocalizedString("Dismiss", comment: "ContactPickerViewController : dismissButton : titleText")
        let settingsText            = NSLocalizedString("Go To Settings", comment: "ContactPickerViewController : dismissButton : titleText")
        
        let alertController = UIAlertController(title:alertMessage, message:nil, preferredStyle: UIAlertControllerStyle.Alert)
        let settingsAction = UIAlertAction(title: settingsText, style: .Default)  { [unowned self] action in
            UIApplication.sharedApplication().navigateToSettings()
            self.pop()
        }
        let dismissAction = UIAlertAction(title: dismissText, style: .Cancel)  { [unowned self] action in
            self.pop()
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func didSelectPerson(person: ABRecordRef) {
        if let rc = contactManager.remoteUserForPerson(person) {
            remoteContact = rc
            theView.populateContact(remoteContact)
        } else {
            theView.hideContact()
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                let aTitle = NSLocalizedString("Well, that contact does have email or a phone number", comment: "ContactPickerViewController : alertTile : no email or phone")
                let mess = NSLocalizedString("Try again.", comment: "ContactPickerViewController : alertMessage : tryagain")
                self?.showAlert(aTitle, message:mess) { [weak self] in
                    self?.pop()
                }
            }
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

    
    func sendEmail(info:EmailInfo) {
        emailDelegate = EmailDelegate()
        emailDelegate?.email(self, info: info) { [unowned self] isSent in
            if isSent {
                self.managedObjectContext.send(self.remotePlace, toContact:self.remoteContact)
            }
            self.emailDelegate = nil
            self.pop()
        }
    }
    
    func sendTextMessage(info:TextInfo) {
        textDelegate = TextDelegate()
        textDelegate?.text(self, info: info) { [unowned self] isSent in
            if isSent {
                self.managedObjectContext.send(self.remotePlace, toContact:self.remoteContact)
            }
            self.textDelegate = nil
            self.pop()
        }
    }
    
}

extension ContactPickerViewController : ABPeoplePickerNavigationControllerDelegate {
   
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef) {
        didSelectPerson(person)
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }

    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecordRef) -> Bool {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        return false;
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }

}