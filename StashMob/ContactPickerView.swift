//
//  ContactPickerView.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import StashMobModel
import GoogleMaps

class ContactPickerView: UIView {

    @IBOutlet weak var sendButton:UIButton?
    @IBOutlet weak var dontSendButton:UIButton?
    @IBOutlet weak var placeNameLabel:UILabel?
    @IBOutlet weak var contactNameLabel:UILabel?
    @IBOutlet weak var contactWidthConstraint:NSLayoutConstraint?
    @IBOutlet weak var mapView:GMSMapView?
    @IBOutlet weak var subLabel:UILabel?
    @IBOutlet weak var toLabel:UILabel?
    @IBOutlet weak var contactImageView:UIImageView?
 
    func didload() {
        let sendText                        = NSLocalizedString("YES SEND!!", comment: "ContactPickerView : send : text")
        let dontSendText                    = NSLocalizedString("NO WHOOPS!", comment: "ContactPickerView : send : text")
        
        sendButton?.setTitle(sendText, forState: .Normal)
        dontSendButton?.setTitle(dontSendText, forState: .Normal)
        
        toLabel?.text                       = NSLocalizedString("Send", comment: "ContactPickerView : toLabel : text")
        subLabel?.text                      = NSLocalizedString("to", comment: "ContactPickerView : sublabel : text")
        
        placeNameLabel?.numberOfLines       = 0
        placeNameLabel?.font                = UIFont.boldSystemFontOfSize(24)
        placeNameLabel?.adjustsFontSizeToFitWidth = true

        contactNameLabel?.adjustsFontSizeToFitWidth = true
        contactNameLabel?.font              = UIFont.boldSystemFontOfSize(24)
    }
    
    func populatePlace(place:RemotePlace) {
        placeNameLabel?.text                = place.name
    }

    func populateContact(contact:RemoteContact) {
        let fn                              = contact.fullName
        contactNameLabel?.text              = fn
        
        let w                               = fn.widthWithConstrainedHeight(40, font: contactNameLabel!.font) + 80
        let max                             = ScreenSize.SCREEN_WIDTH - 80
        contactWidthConstraint?.constant    = min(w, max)

        contactImageView?.image             = contact.getImage()
    }

    func hideContact() {
        contactNameLabel?.hidden            = true
        contactImageView?.hidden            = true
    }
    
}
