//
//  TwoListViewable.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//


import UIKit

protocol TwoListViewable:class {
    var titleLabel:UILabel? { get set }
    var tableView:UITableView? { get set }
    var leftButton:UIButton? { get set }
    var rightButton:UIButton? { get set }
    var backButton:UIButton?  { get set }
    var emptyStateView:UIView? { get set }
    var emptyStateLabel:UILabel? { get set }
    var emptyStateLeftString:String { get set }
    var emptyStateRightString:String { get set }
}

extension TwoListViewable {
    func emptyForRight() {
        emptyStateView?.hidden  = false
        emptyStateLabel?.text   = emptyStateRightString
    }
    
    func emptyForLeft() {
        emptyStateView?.hidden  = false
        emptyStateLabel?.text   = emptyStateLeftString
    }
    
    func hideEmptyState () {
        emptyStateView?.hidden  = true
    }
    
    func highlightRecieved() {
        rightButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        leftButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        leftButton?.backgroundColor = UIColor.whiteColor()
        rightButton?.backgroundColor = UIColor.blueColor()
    }
    
    func highlightSent() {
        rightButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        leftButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightButton?.backgroundColor = UIColor.whiteColor()
        leftButton?.backgroundColor = UIColor.blueColor()
    }
}
