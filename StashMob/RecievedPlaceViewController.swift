//
//  RecievedPlaceViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import StashMobModel

class RecievedPlaceViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable {
        
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    private var gmController:GMCenteredController!
    
    var remoteContact:RemoteContact!
    var remotePlace:RemotePlace? {
        didSet {
           updatePlaceAndMap()
        }
    }
    var placeId:String?
    
    var theView:RecievedPlaceView {
        guard let v = view as? RecievedPlaceView else { fatalError("The view is not a RecievedPlaceView") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theView.didload()
        theView.populateContact(remoteContact)
        if let pm = placeId {
            fetchPlace(pm)
            return
        }
        updatePlaceAndMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        theView.exitButton?.addTarget(self, action: #selector(dismiss), forControlEvents: .TouchUpInside)
    }
    
    func removeHandlers() {
        theView.exitButton?.removeTarget(self, action: #selector(dismiss), forControlEvents: .TouchUpInside)
    }
    
    // MARK : Button handlers
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    func savePlace() {
        guard let rp = remotePlace else {
            return
        }
        managedObjectContext.recieve(rp, fromContact:self.remoteContact)
    }
    
    func fetchPlace(placeId:String) {
        let placeClient             = GMSPlacesClient()
        placeClient.lookUpPlaceID(placeId, callback: { [weak self] place, error in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                self?.alertBadThingsWithRetryBlock {
                    self?.dismiss()
                }
                return
            }
            
            if let place = place {
                self?.remotePlace = place.toRemotePlace()
                self?.savePlace()
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
            } else {
                self?.alertBadThingsWithRetryBlock {
                    self?.dismiss()
                }
            }
        })

    }
    
    func updatePlaceAndMap() {
        guard let rp = remotePlace else {
            return
        }
        theView.populatePlace(rp)
        gmController                = GMCenteredController(mapView: theView.mapView!, coordinate:rp.coordinate, image:remoteContact.getPinImage() )
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Alert
    
    func alertBadThingsWithRetryBlock(block:()->()) {
        let alertTitle              = NSLocalizedString("Whoa! Thats not a place", comment: "RecievedPlaceViewController : error : alertTitle  ")
        let alertMessage            = NSLocalizedString("Lets get outta here!", comment: "RecievedPlaceViewController : error : message")
        
        let dismissText             = NSLocalizedString("Dismiss", comment: "RecievedPlaceViewController : error : forgetit")
        
        let alertController         = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction          = UIAlertAction(title: dismissText, style: .Default)  { action in
            block()
        }
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
