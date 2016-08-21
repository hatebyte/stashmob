//
//  PlaceFeatureTableViewCell.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

public let PlaceFeatureTableViewCellHeight:CGFloat        = 50.0
class PlaceFeatureTableViewCell: UITableViewCell {
    
    static let Identifier:String            = "PlaceFeatureTableViewCell"
    
    @IBOutlet weak var keyLabel:UILabel?
    @IBOutlet weak var valueLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        keyLabel?.font = UIFont.boldSystemFontOfSize(10)
        keyLabel?.adjustsFontSizeToFitWidth = true
        
        valueLabel?.font = UIFont.systemFontOfSize(12)
        valueLabel?.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
    }

}

extension PlaceFeatureTableViewCell : ConfigurableCell {
    func configureForObject(object:PlaceFeature) {
        keyLabel?.text = object.key
        valueLabel?.text = object.value
    }
}