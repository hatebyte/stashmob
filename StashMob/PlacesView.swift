//
//  PlacesView.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

class PlacesView: UIView {

    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var receivedButton:UIButton?
    @IBOutlet weak var sentButton:UIButton?
    @IBOutlet weak var backButton:UIButton?
    @IBOutlet weak var emptyStateView:UIView?
    @IBOutlet weak var emptyStateLabel:UILabel?
    
    func didload() {
        emptyStateLabel?.font   = UIFont.boldSystemFontOfSize(12)
        emptyStateLabel?.numberOfLines = 0
       
        titleLabel?.text        = NSLocalizedString("YOUR PLACES", comment: "PlacesView : titleLabel : text ")
        titleLabel?.font        = UIFont.boldSystemFontOfSize(14)

        receivedButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        sentButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
   
        let sentText   = NSLocalizedString("Sent", comment: "PlacesView : sentButton : titleText ")
        let receievedText   = NSLocalizedString("Recieved", comment: "PlacesView : receivedButton : titleText ")
        receivedButton?.setTitle(receievedText, forState: .Normal)
        sentButton?.setTitle(sentText, forState: .Normal)
    }
    
    func emptyForReceived() {
        emptyStateView?.hidden  = false
        emptyStateLabel?.text   = NSLocalizedString("You haven't received any places yet", comment: "PlacesView : emptyStateLabel : received ")
    }
    
    func emptyForSent() {
        emptyStateView?.hidden  = false
        emptyStateLabel?.text   = NSLocalizedString("You haven't sent any places yet", comment: "PlacesView : emptyStateLabel : sent")
    }
   
    func hideEmptyState () {
        emptyStateView?.hidden  = true
    }
    
    func highlightRecieved() {
        receivedButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sentButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        sentButton?.backgroundColor = UIColor.whiteColor()
        receivedButton?.backgroundColor = UIColor.blueColor()
    }
    
    func highlightSent() {
        receivedButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        sentButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        receivedButton?.backgroundColor = UIColor.whiteColor()
        sentButton?.backgroundColor = UIColor.blueColor()
    }
    
}
