//
//  ContactView.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import StashMobModel

class ContactView: UIView, TwoListViewable {
    
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var rightButton:UIButton?
    @IBOutlet weak var leftButton:UIButton?
    @IBOutlet weak var backButton:UIButton?
    @IBOutlet weak var emptyStateView:UIView?
    @IBOutlet weak var emptyStateLabel:UILabel?
    
    @IBOutlet weak var avatarImageView:UIImageView?
    
    var  emptyStateRightString   = NSLocalizedString("You haven't received any places from this contact yet", comment: "ContactsView : emptyStateLabel : received ")
    var  emptyStateLeftString  = NSLocalizedString("You haven't sent any places to this contact yet", comment: "ContactView : emptyStateLabel : sent")
    
    func didload() {
        avatarImageView?.clipsToBounds = true
        
        emptyStateLabel?.font   = UIFont.boldSystemFontOfSize(12)
        emptyStateLabel?.numberOfLines = 0
        
        titleLabel?.font        = UIFont.boldSystemFontOfSize(14)
        
        rightButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        leftButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        let sentText            = NSLocalizedString("Sent To", comment: "ContactView : sentButton : titleText ")
        let receievedText       = NSLocalizedString("From", comment: "ContactView : receivedButton : titleText ")
        rightButton?.setTitle(receievedText, forState: .Normal)
        leftButton?.setTitle(sentText, forState: .Normal)
        layoutIfNeeded()
    }

    func populate(contact:RemoteContact) {
        avatarImageView?.image = contact.getImage()
        titleLabel?.text = contact.fullName
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView?.layer.cornerRadius = min(avatarImageView!.frame.size.height, avatarImageView!.frame.size.width) / 2.0
    }

}
