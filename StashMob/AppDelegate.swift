//
//  AppDelegate.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import StashMobModel
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context:NSManagedObjectContext!
    var navController:FMNavigationController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey(NSBundle.mainBundle().googlePlacesKey)
        GMSServices.provideAPIKey(NSBundle.mainBundle().googleMapsKey)
        
        guard let mcontext = createMainContext() else { fatalError("BIG PROBLEMS OUT THE DOOR!!!") }
        context                                     = mcontext

        navController                               = UIStoryboard.navigationViewController()
        let rootVC                                  = UIStoryboard.rootController()
        rootVC.managedObjectContext                 = context
        navController.viewControllers               = [rootVC]
        
        self.window                                 = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window?.rootViewController             = navController
        self.window?.frame                          = UIScreen.mainScreen().bounds
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {

    }

    //MARK: Open URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("LAUNCHED FROM TEXT : \(url.absoluteString)")
        return false
    }
    
    //MARK: Deep Linking
    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                let webpageURL = userActivity.webpageURL! // Always exists
                print("LAUNCHED FROM TEXT ioS8 : \(webpageURL.absoluteString)")
        }
        return false
    }
}

