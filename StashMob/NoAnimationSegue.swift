//
//  NoAnimationSegue.swift
//  StashMob
//
//  Created by Scott Jones on 8/22/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

class NoAnimationSegue: UIStoryboardSegue {

    override func perform() {
        let nav = sourceViewController.navigationController
        nav?.pushViewController(destinationViewController, animated: false)
    }
    
}
