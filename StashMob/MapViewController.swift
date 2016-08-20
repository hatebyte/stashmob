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

class MapViewController: UIViewController, ManagedObjectContextSettable, SegueHandlerType {

    weak var managedObjectContext: NSManagedObjectContext!
    private var placePicker: GMSPlacePicker?
    private var locationManager:UserMovementManager?
    
    var remotePlace:RemotePlace?
    
    enum SegueIdentifier:String {
        case PushToContactPicker                   = "pushToContactPicker"
    }
    
    var theView:MapView {
        guard let v = view as? MapView else { fatalError("The view is not a MapView") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        theView.didload()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addHandlers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeHandlers()
    }
    
    func addHandlers() {
        theView.findPlaceButton?.addTarget(self, action: #selector(findPlaceRequested), forControlEvents: .TouchUpInside)
        theView.seePeopleButton?.addTarget(self, action: #selector(seePeopleRequested), forControlEvents: .TouchUpInside)
        theView.seePlacesButton?.addTarget(self, action: #selector(seePlacesRequested), forControlEvents: .TouchUpInside)
    }
    
    func removeHandlers() {
        theView.findPlaceButton?.removeTarget(self, action: #selector(findPlaceRequested), forControlEvents: .TouchUpInside)
        theView.seePeopleButton?.removeTarget(self, action: #selector(seePeopleRequested), forControlEvents: .TouchUpInside)
        theView.seePlacesButton?.removeTarget(self, action: #selector(seePlacesRequested), forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Button handlers
    func findPlaceRequested() {
        locationManager                         = UserMovementManager()
        locationManager?.startUpdating { [weak self] location in
            self?.locationManager?.stopUpdating()
            self?.addPicker(location)
        }
    }
    
    func seePeopleRequested() {
        
    }
    
    func seePlacesRequested() {
        
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
                NSLog("An error occurred while picking a place: \(error)")
            } else {
                NSLog("Looks like the place picker was canceled by the user")
            }
            
            self?.placePicker = nil
        }
    }

    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .PushToContactPicker:
            guard let vc                             = segue.destinationViewController as? ContactPickerViewController else { fatalError("DestinationViewController \(segue.destinationViewController.self) does not conform to ManagedObjectContextSettable") }
            vc.managedObjectContext                  = managedObjectContext
            guard let rp                             = remotePlace else { fatalError("We lost our remote place") }
            vc.remotePlace                           = rp
        }
        
    }
    
}

