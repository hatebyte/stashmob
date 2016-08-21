//
//  PlaceTableViewCell.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import StashMobModel

public let PlaceTableViewCellHeight:CGFloat        = 50.0
class PlaceTableViewCell: UITableViewCell {
    
    static let Identifier:String            = "PlaceTableViewCell"
    
    @IBOutlet weak var nameLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel?.font = UIFont.boldSystemFontOfSize(10)
        nameLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
}

extension PlaceTableViewCell : ConfigurableCell {
    func configureForObject(object:RemotePlace) {
        nameLabel?.text = object.name ?? "\(object.latitude), \(object.longitude)"
    }
}