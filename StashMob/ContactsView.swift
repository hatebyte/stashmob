//
//  ContactsView.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//
import UIKit

class ContactsView: UIView, TwoListViewable {
    
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var rightButton:UIButton?
    @IBOutlet weak var leftButton:UIButton?
    @IBOutlet weak var backButton:UIButton?
    @IBOutlet weak var emptyStateView:UIView?
    @IBOutlet weak var emptyStateLabel:UILabel?
    
    var  emptyStateLeftString   = NSLocalizedString("You haven't received any places from anyone yet", comment: "ContactsView : emptyStateLabel : received ")
    var  emptyStateRightString  = NSLocalizedString("You haven't sent any places to anyone yet", comment: "ContactsView : emptyStateLabel : sent")
    
    func didload() {
        emptyStateLabel?.font   = UIFont.boldSystemFontOfSize(12)
        emptyStateLabel?.numberOfLines = 0
        
        titleLabel?.text        = NSLocalizedString("YOUR CONTACTS", comment: "ContactsView : titleLabel : text ")
        
        titleLabel?.font        = UIFont.boldSystemFontOfSize(14)
        
        rightButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        leftButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        let sentText            = NSLocalizedString("Sent", comment: "ContactsView : sentButton : titleText ")
        let receievedText       = NSLocalizedString("Recieved", comment: "ContactsView : receivedButton : titleText ")
        rightButton?.setTitle(receievedText, forState: .Normal)
        leftButton?.setTitle(sentText, forState: .Normal)
    }

}
