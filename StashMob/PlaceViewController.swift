//
//  PlaceViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import StashMobModel

class PlaceViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable, SegueHandlerType {
    
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    private typealias Data = DefaultDataProvider<PlaceViewController>
    private var dataSource:TableViewDataSource<PlaceViewController, Data, ContactTableViewCell>!
    private var dataProvider: Data!
    private var gmController:GMCenteredController!
 
    var theView:TwoListViewable {
        guard let v = view as? TwoListViewable else { fatalError("The view is not a TwoListViewable") }
        return v
    }
    
    var remotePlace : RemotePlace!
    var remoteContactSelected:RemoteContact?
    var selectedPlaceRelation:PlaceRelation = .Sent
    
    enum SegueIdentifier:String {
        case PushToPlaceDetail                         = "pushToPlaceDetail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = theView as? PlaceView
        v?.didload()
        v?.populate(remotePlace)
        gmController                                   = GMCenteredController(mapView: v!.mapView!, coordinate:remotePlace.coordinate, image:UIImage(named:"event_pin"))
        sentPicked()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if #available(iOS 8.3, *) {
            managedObjectContext.refreshAllObjects()
        }
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
        theView.leftButton?.addTarget(self, action: #selector(sentPicked), forControlEvents: .TouchUpInside)
        theView.rightButton?.addTarget(self, action: #selector(receivedPicked), forControlEvents: .TouchUpInside)
        theView.backButton?.addTarget(self, action: #selector(pop), forControlEvents: .TouchUpInside)
    }
    
    func removeHandlers() {
        theView.leftButton?.removeTarget(self, action: #selector(sentPicked), forControlEvents: .TouchUpInside)
        theView.rightButton?.removeTarget(self, action: #selector(receivedPicked), forControlEvents: .TouchUpInside)
        theView.backButton?.removeTarget(self, action: #selector(pop), forControlEvents: .TouchUpInside)
    }
    
    var wasSent:Bool {
        return theView.leftButton?.backgroundColor == UIColor.blueColor()
    }
    
    // MARK: ButtonHandlers
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func receivedPicked() {
        let received                                = managedObjectContext.contactsWhoSentMePlace(remotePlace)
        theView.highlightRecieved()
        
        if received.count == 0 {
            theView.emptyForRight()
            return
        }
        theView.hideEmptyState()
        dataProvider                                = DefaultDataProvider(items:received, delegate :self)
        dataSource                                  = TableViewDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate                 = self
    }
    
    func sentPicked() {
        let sent                                    = managedObjectContext.contactsWhoWereSentPlace(remotePlace)
        theView.highlightSent()
        
        if sent.count == 0 {
            theView.emptyForLeft()
            return
        }
        theView.hideEmptyState()
        dataProvider                                = DefaultDataProvider(items:sent, delegate :self)
        dataSource                                  = TableViewDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate                 = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mcs                               = segue.destinationViewController as? ManagedObjectContextSettable else { fatalError("DestinationViewController \(segue.destinationViewController.self) is not ManagedObjectContextSettable") }
        mcs.managedObjectContext                    = managedObjectContext
        
        switch segueIdentifierForSegue(segue) {
        case .PushToPlaceDetail:
            guard let vc = mcs as? DetailPlaceViewController else {
                fatalError("DestinationViewController \(segue.destinationViewController.self) is not DetailPlaceViewController")
            }
            guard let rcs = remoteContactSelected else { fatalError("Contact selected with out remoteContactSelected") }
            vc.remoteContact                        = rcs
            vc.placeRelation                        = selectedPlaceRelation
            vc.placeId                              = remotePlace.placeId
            vc.remotePlace                          = remotePlace
        }
    }
    
}

extension PlaceViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact                     = dataProvider.objectAtIndexPath(indexPath)
        remoteContactSelected           = contact
        selectedPlaceRelation           = (wasSent) ? .Sent : .Received
        
        performSegue(.PushToPlaceDetail)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ContactTableViewCellHeight
    }
    
}

extension PlaceViewController : DataProviderDelegate {
    func dataProviderDidUpdate(updates:[DataProviderUpdate<RemoteContact>]?) {
    }
}

extension PlaceViewController : DataSourceDelegate {
    func cellIdentifierForObject(object:RemoteContact) -> String {
        return ContactTableViewCell.Identifier
    }
}