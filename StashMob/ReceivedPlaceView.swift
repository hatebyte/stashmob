//
//  ReceivedPlaceView.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import GoogleMaps
import StashMobModel

class RecievedPlaceView: UIView {

    @IBOutlet weak var exitButton:UIButton?
    @IBOutlet weak var placeNameLabel:UILabel?
    @IBOutlet weak var contactNameLabel:UILabel?
    @IBOutlet weak var contactWidthConstraint:NSLayoutConstraint?
    @IBOutlet weak var mapView:GMSMapView?
    @IBOutlet weak var sentYouLabel:UILabel?
    @IBOutlet weak var contactImageView:UIImageView?
    
    func didload() {
        let sendText                        = NSLocalizedString("Close X", comment: "ReceivedPlaceView : close : text")
        exitButton?.setTitle(sendText, forState: .Normal)
        
        sentYouLabel?.text                  = NSLocalizedString("sent you", comment: "ReceivedPlaceView : sentYouLabel : text")
        
        placeNameLabel?.numberOfLines       = 0
        placeNameLabel?.font                = UIFont.boldSystemFontOfSize(24)
        placeNameLabel?.adjustsFontSizeToFitWidth = true
        
        contactNameLabel?.adjustsFontSizeToFitWidth = true
        contactNameLabel?.font              = UIFont.boldSystemFontOfSize(24)
    }
    
    func populateContact(contact:RemoteContact) {
        let fn                              = contact.fullName
        contactNameLabel?.text              = fn
        
        let w                               = fn.widthWithConstrainedHeight(40, font: contactNameLabel!.font) + 80
        let max                             = ScreenSize.SCREEN_WIDTH - 80
        contactWidthConstraint?.constant    = min(w, max)
        
        contactImageView?.image             = contact.getImage()
    }

    func populatePlace(place:RemotePlace) {
        placeNameLabel?.text                = place.name
    }
    
}