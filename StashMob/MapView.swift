//
//  MapView.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

class MapView: UIView {
    
    @IBOutlet weak var findPlaceButton:UIButton?
    @IBOutlet weak var seePeopleButton:UIButton?
    @IBOutlet weak var seePlacesButton:UIButton?
    
    func didload() {
        let findButtonText = NSLocalizedString("Find Places", comment: "MapView : findPlaceButton : titleText")
        findPlaceButton?.setTitle(findButtonText, forState: .Normal)
        let seePeopleText = NSLocalizedString("See Your People", comment: "MapView : seePeopleButton : titleText")
        seePeopleButton?.setTitle(seePeopleText, forState: .Normal)
        let seePlacesText = NSLocalizedString("See Your Places", comment: "MapView : seePlacesButton : titleText")
        seePlacesButton?.setTitle(seePlacesText, forState: .Normal)
    }
    
}
