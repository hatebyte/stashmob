//
//  ContactTableViewCell.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit


import StashMobModel

public let ContactTableViewCellHeight:CGFloat        = 50.0
class ContactTableViewCell: UITableViewCell {
    
    static let Identifier:String            = "ContactTableViewCell"
    
    @IBOutlet weak var nameLabel:UILabel?
    @IBOutlet weak var avatarImageView:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel?.font = UIFont.boldSystemFontOfSize(10)
        nameLabel?.adjustsFontSizeToFitWidth = true
        
        avatarImageView?.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView?.layer.cornerRadius = min(avatarImageView!.frame.size.height, avatarImageView!.frame.size.width) / 2.0
    }
    
}

extension ContactTableViewCell : ConfigurableCell {
    func configureForObject(object:RemoteContact) {
        nameLabel?.text = object.fullName
        avatarImageView?.image = object.getImage()
    }
}