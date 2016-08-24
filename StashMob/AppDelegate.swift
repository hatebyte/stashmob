//
//  AppDelegate.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context:NSManagedObjectContext!
    var navController:FMNavigationController!
    var contactManager = ContactManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey(NSBundle.mainBundle().googlePlacesKey)
        GMSServices.provideAPIKey(NSBundle.mainBundle().googleMapsKey)
        
        guard let mcontext = createMainContext() else { fatalError("BIG PROBLEMS OUT THE DOOR!!!") }
        context                                     = mcontext

        navController                               = UIStoryboard.navigationViewController()
        navController.managedObjectContext          = context
        navController.contactManager                = contactManager
 
        let rootVC                                  = UIStoryboard.rootController()
        rootVC.managedObjectContext                 = context
        rootVC.contactManager                       = contactManager
        navController.viewControllers               = [rootVC]
        
        window                                      = UIWindow(frame:UIScreen.mainScreen().bounds)
        window?.rootViewController                  = navController
        window?.frame                               = UIScreen.mainScreen().bounds
        window?.makeKeyAndVisible()
        
        navController.checkLoggedIn()
        if !navController.isLoggedIn {
            let place = RemotePlace(
                 placeId            : "place_id_def"
                ,name               : "Malrooneys Park"
                ,address            : "122 Buttercup Lane"
                ,latitude           : 47.0
                ,longitude          : 74.0
                ,phoneNumber        : "9085818600"
                ,priceLevel         : 12
                ,rating             : 3.0
                ,status             : 3
                ,types              : ["nice", "smelly"]
                ,websiteUrlString   : "https://reddit.com/r/swift"
            )
            let p = place.insertIntoContext(context)
            for i in 0..<100 {
                let contact = RemoteContact(
                     phoneNumber        : "908581\(i)"
                    ,email              : "mylegfeels\(i)funney@gmail.com"
                    ,firstName          : "Scott \(i)"
                    ,lastName           : "Jones"
                    ,imageName          : "avatar"
                )
                let c = contact.insertIntoContext(context)
                c.addToSentPlaces(p)
            }
            context.saveOrRollback()
        }
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

    //MARK: Deep Linking
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        guard let receivedItem = url.receivedItem else { return false }
        navController.accept(receivedItem)
        return false
    }
    
    //MARK: Deep Linking
    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                _ = userActivity.webpageURL! // Always exists

        }
        return false
    }
}

