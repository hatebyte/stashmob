//
//  TextDelegate.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import MessageUI

public typealias TextClosure                           = ()->()

public struct TextInfo {
    let messageString:String
    let toRecipentsArray:[String]
    
    public init(messageString:String, toRecipentsArray:[String]) {
        self.messageString              = messageString
        self.toRecipentsArray           = toRecipentsArray
    }
}

public class TextDelegate: NSObject, MFMessageComposeViewControllerDelegate  {
    
    private var superVC:UIViewController!
    private var complete:TextClosure!
    
    //MARK: Send to Email
    public func text(vc:UIViewController, info:TextInfo, complete:TextClosure) {
        self.superVC = vc
        self.complete                                   = complete
    
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = info.toRecipentsArray
        messageComposeVC.body = info.messageString
        
        if MFMessageComposeViewController.canSendText() {
            superVC.presentViewController(messageComposeVC, animated:true, completion: { () -> Void in
                
            })
        }
        
    }
   
    public func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue:
            print("Mail cancelled");
        case MessageComposeResultSent.rawValue:
            print("Mail sent");
        case MessageComposeResultFailed.rawValue:
            print("Mail sent failure");
        default:
            break
        }
        superVC.dismissViewControllerAnimated(true, completion:self.complete)
    }
    
}