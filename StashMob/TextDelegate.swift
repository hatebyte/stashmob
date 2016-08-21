//
//  TextDelegate.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import MessageUI

public typealias TextClosure                           = (Bool)->()

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
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(false)
            }
        case MessageComposeResultSent.rawValue:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(true)
            }
        case MessageComposeResultFailed.rawValue:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(false)
            }
        default:
            superVC.dismissViewControllerAnimated(true) { [weak self] in
                self?.complete(false)
            }
        }
    }
    
}