//
//  EmailDelegate.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

import MessageUI

public typealias EmailClosure                           = (Bool)->()

public struct EmailInfo {
    let titleString:String
    let messageString:String
    let toRecipentsArray:[String]
    
    public init(titleString:String, messageString:String, toRecipentsArray:[String]) {
        self.titleString                = titleString
        self.messageString              = messageString
        self.toRecipentsArray           = toRecipentsArray
    }
}

public class EmailDelegate: NSObject, MFMailComposeViewControllerDelegate  {
    
    private var superVC:UIViewController!
    private var complete:EmailClosure!
    
    //MARK: Send to Email
    public func email(vc:UIViewController, info:EmailInfo, complete:EmailClosure) {
        self.superVC = vc
        self.complete                                   = complete
        let mailClass: AnyClass!                        = NSClassFromString("MFMailComposeViewController");
        
        if (mailClass != nil) {
            let mailController                          = MFMailComposeViewController()
            mailController.mailComposeDelegate          = self;
            mailController.setSubject(info.titleString)
            mailController.setMessageBody(info.messageString, isHTML: false)
            mailController.setToRecipients(info.toRecipentsArray)
            
            if mailClass.canSendMail() == true {
                superVC.presentViewController(mailController, animated:true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(false)
            }
        case MFMailComposeResultSaved.rawValue:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(false)
            }
        case MFMailComposeResultSent.rawValue:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(true)
            }
        case MFMailComposeResultFailed.rawValue:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(false)
            }
        default:
           break
        }
    }
    
}