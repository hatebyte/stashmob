//
//  PlaceView.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceView: UIView, TwoListViewable {
    
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var rightButton:UIButton?
    @IBOutlet weak var leftButton:UIButton?
    @IBOutlet weak var backButton:UIButton?
    @IBOutlet weak var emptyStateView:UIView?
    @IBOutlet weak var emptyStateLabel:UILabel?
    
    var  emptyStateLeftString   = NSLocalizedString("You haven't received this place from anyone yet", comment: "PlaceView : emptyStateLabel : received ")
    var  emptyStateRightString  = NSLocalizedString("You haven't sent this place to anyone yet", comment: "PlaceView : emptyStateLabel : sent")
   
    @IBOutlet weak var mapView:GMSMapView?
    
    func didload() {
        emptyStateLabel?.font   = UIFont.boldSystemFontOfSize(12)
        emptyStateLabel?.numberOfLines = 0
        
        titleLabel?.font        = UIFont.boldSystemFontOfSize(14)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 0
        
        rightButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        leftButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        let sentText            = NSLocalizedString("Sent To", comment: "PlaceView : sentButton : titleText ")
        let receievedText       = NSLocalizedString("Recieved From", comment: "PlaceView : receivedButton : titleText ")
        rightButton?.setTitle(receievedText, forState: .Normal)
        leftButton?.setTitle(sentText, forState: .Normal)
    }
    
    func populate(place:RemotePlace) {
        titleLabel?.text = place.name
    }
    
}