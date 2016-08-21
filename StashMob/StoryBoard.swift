//
//  StoryBoard.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

extension UIStoryboard {
   
    static var mainStoryBoard:UIStoryboard {
        return UIStoryboard(name:"Main", bundle:nil)
    }
    
    static func rootController()->MapViewController {
        guard let rootController = mainStoryBoard.instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController
            else { fatalError("The storyboard has no rootViewController") }
        return rootController
    }
   
    static func navigationViewController()->FMNavigationController {
        guard let navController = mainStoryBoard.instantiateInitialViewController() as? FMNavigationController
            else { fatalError("The storyboard has the wrong type of navigation controller") }
        return navController
    }
    
    static func receivedModal()->DetailPlaceViewController {
        guard let controller = mainStoryBoard.instantiateViewControllerWithIdentifier("DetailPlaceViewController") as? DetailPlaceViewController
            else { fatalError("The storyboard has no RecievedPlaceViewController") }
        return controller
    }

    static func loginModal()->LoginViewController {
        guard let controller = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
            else { fatalError("The storyboard has no LoginViewController") }
        return controller
    }

    
    
}