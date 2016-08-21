//
//  ViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import GooglePlacePicker
import StashMobModel

class MapViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable, SegueHandlerType {

    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    private var placePicker: GMSPlacePicker?
    private var locationManager = UserLocationManager()
    private var locationPermissions:LocationPermissionsManager!
    private var gmController:GMMultiMarkerController!
    
    var remotePlace:RemotePlace?
    
    enum SegueIdentifier:String {
        case PushToContactPicker                    = "pushToContactPicker"
        case PushToPlaces                           = "pushToPlaces"
        case PushToContacts                         = "pushToContacts"
    }
    
    var theView:MapView {
        guard let v = view as? MapView else { fatalError("The view is not a MapView") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationPermissions = LocationPermissionsManager(locationManager: locationManager)
        theView.didload()
        gmController = GMMultiMarkerController(mapView: theView.mapView!)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addHandlers()
        
        // For some reason, the GMCamera does not update on first launch
        let pandp                                   = managedObjectContext.mapContactsToPersonAndPlaces()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            self?.gmController.update(pandp.sent, received: pandp.received)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeHandlers()
    }
    
    func addHandlers() {
        theView.findPlaceButton?.addTarget(self, action: #selector(findAPlaceRequested), forControlEvents: .TouchUpInside)
        theView.seePeopleButton?.addTarget(self, action: #selector(seePeopleRequested), forControlEvents: .TouchUpInside)
        theView.seePlacesButton?.addTarget(self, action: #selector(seePlacesRequested), forControlEvents: .TouchUpInside)
    }
    
    func removeHandlers() {
        theView.findPlaceButton?.removeTarget(self, action: #selector(findAPlaceRequested), forControlEvents: .TouchUpInside)
        theView.seePeopleButton?.removeTarget(self, action: #selector(seePeopleRequested), forControlEvents: .TouchUpInside)
        theView.seePlacesButton?.removeTarget(self, action: #selector(seePlacesRequested), forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if #available(iOS 8.3, *) {
            managedObjectContext.refreshAllObjects()
        }
    }
    
    
    // MARK: Button handlers
    func findAPlaceRequested() {
        if locationPermissions.hasLocationSettingsTurnedOn() {
            actionSheetForLocationOrSearch()
        } else if managedObjectContext.hasBeenAskedForLocationInformation == false {
            locationPermissions.askForLocationPermission({ [weak self] in
                self?.actionSheetForLocationOrSearch()
                }, denied: { [weak self] in
                    self?.alertNeedLocationsInSettings()
            })
            managedObjectContext.performChangesAndWait { [unowned self] in
                self.managedObjectContext.saveHasBeenAskedForLocationInformation()
            }
        } else {
            alertDeniedLocationSettings()
        }
    }
    
    func seePeopleRequested() {
        performSegue(.PushToContacts)
    }
    
    func seePlacesRequested() {
        performSegue(.PushToPlaces)
    }
    
    // MARK: Location
    func startLocating() {
        locationManager.startUpdating { [weak self] location in
            self?.locationManager.stopUpdating()
            self?.addPicker(location)
        }
    }
    
    func sendToSearchBar() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    
    // MARK: Place Picker
    func addPicker(center:CLLocationCoordinate2D) {
        let northEast           = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest           = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport            = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config              = GMSPlacePickerConfig(viewport: viewport)
        placePicker             = GMSPlacePicker(config: config)
       
        placePicker?.pickPlaceWithCallback { [weak self] (place, error) in
            
            if let place = place {
                self?.remotePlace = place.toRemotePlace()
                self?.performSegue(.PushToContactPicker)
                
            } else if error != nil {
                self?.alertBadThingsWithRetryBlock { [weak self] in
                    self?.addPicker(center)
                }
            } else {
                NSLog("Looks like the place picker was canceled by the user")
            }
            
            self?.placePicker = nil
        }
    }

    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mcs                               = segue.destinationViewController as? ManagedObjectContextSettable else { fatalError("DestinationViewController \(segue.destinationViewController.self) is not ManagedObjectContextSettable") }
        mcs.managedObjectContext                    = managedObjectContext

        switch segueIdentifierForSegue(segue) {
        case .PushToContactPicker:
            guard let vc                             = segue.destinationViewController as? ContactPickerViewController else { fatalError("DestinationViewController \(segue.destinationViewController.self) is not ContactPickerViewController") }
            vc.contactManager                        = contactManager

            guard let rp                             = remotePlace else { fatalError("We lost our remote place") }
            vc.remotePlace                           = rp
            
        case .PushToPlaces: break
        case .PushToContacts: break
        }
    }
    
    // MARK: Alerts
    func alertNeedLocationsInSettings() {
        let alertTitle              = NSLocalizedString("Well Hmm, we do need locations access to get this done.", comment: "MapViewController : alertTitle : nolocation")
        let alertMessage            = NSLocalizedString("We are going to force you to search for a place if you dont give us access to your location.", comment: "MapViewController : alertmessage : nolocation")
        
        let dismissText             = NSLocalizedString("Dismiss", comment: "ContactPickerViewController : dismissButton : titleText")
        let settingsText            = NSLocalizedString("Fix In Settings", comment: "ContactPickerViewController : settingsButton : titleText")
        
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let settingsAction = UIAlertAction(title: settingsText, style: .Default)  { action in
            UIApplication.sharedApplication().navigateToSettings()
        }
        let dismissAction = UIAlertAction(title: dismissText, style: .Default)  { [weak self] action in
            self?.sendToSearchBar()
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertDeniedLocationSettings() {
        let alertTitle              = NSLocalizedString("You denied us location", comment: "MapViewController : alertTitle : nolocation")
        let alertMessage            = NSLocalizedString("So we are giving you the search bar.", comment: "MapViewController : alertmessage : nolocation")
        
        let dismissText             = NSLocalizedString("Dismiss", comment: "ContactPickerViewController : dismissButton : titleText")
        let settingsText            = NSLocalizedString("Fix In Settings", comment: "ContactPickerViewController : settingsButton : titleText")
        
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let settingsAction = UIAlertAction(title: settingsText, style: .Default)  { action in
            UIApplication.sharedApplication().navigateToSettings()
        }
        let dismissAction = UIAlertAction(title: dismissText, style: .Cancel)  { [weak self] action in
            self?.sendToSearchBar()
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertBadThingsWithRetryBlock(block:()->()) {
        let alertTitle              = NSLocalizedString("Whoa! Something bad happened", comment: "ContactPickerViewController : error : alertTitle  ")
        let alertMessage            = NSLocalizedString("We could try again?", comment: "ContactPickerViewController : error : message")
        
        let fogetitText             = NSLocalizedString("Nah, forget it", comment: "ContactPickerViewController : error : forgetit")
        let tryagain                = NSLocalizedString("Try again", comment: "ContactPickerViewController : error : tryagain")
        
        let alertController         = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let fogetitAction           = UIAlertAction(title: fogetitText, style: .Cancel)  { action in
        }
        let tryagainAction          = UIAlertAction(title: tryagain, style: .Default)  { action in
            block()
        }
        alertController.addAction(tryagainAction)
        alertController.addAction(fogetitAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func actionSheetForLocationOrSearch() {
        let titleText = NSLocalizedString("How do you want to find a place", comment: "ContactPickerViewController : actionSheetTitle : titleText")
        
        let actionController = UIAlertController(title:titleText, message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let searchText = NSLocalizedString("Search My Self", comment: "ContactPickerViewController : actionSheet : searchButton")
        let currentText = NSLocalizedString("Use CurrentLocation", comment: "ContactPickerViewController : actionSheet : locationButton")
        
        let searchAction = UIAlertAction(title: searchText, style: .Default)  { [weak self] action in
            self?.sendToSearchBar()
        }
        let locationAction = UIAlertAction(title: currentText, style: .Default)  { [weak self] action in
            self?.startLocating()
        }
        actionController.addAction(locationAction)
        actionController.addAction(searchAction)
        presentViewController(actionController, animated: true, completion: nil)
    }
    
}


extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        self.dismissViewControllerAnimated(true) { [weak self] in
            self?.remotePlace = place.toRemotePlace()
            self?.performSegue(.PushToContactPicker)
        }
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        self.dismissViewControllerAnimated(false, completion: nil)
    
        alertBadThingsWithRetryBlock { [weak self] in
            self?.sendToSearchBar()
        }
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}


