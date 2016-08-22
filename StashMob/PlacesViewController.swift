//
//  PlacesViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData

class PlacesViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable, SegueHandlerType {
    
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    private typealias Data = DefaultDataProvider<PlacesViewController>
    private var dataSource:TableViewDataSource<PlacesViewController, Data, PlaceTableViewCell>!
    private var dataProvider: Data!
  
    var remotePlaceSelected:RemotePlace?
    
    var theView:TwoListViewable {
        guard let v = view as? TwoListViewable else { fatalError("The view is not a TwoListViewable") }
        return v
    }
   
    enum SegueIdentifier:String {
        case PushToPlace                         = "pushToPlace"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = theView as? PlacesView
        v?.didload()
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
    
    // MARK: ButtonHandlers
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func receivedPicked() {
        let received                                = managedObjectContext.fetchAllRecievedPlaces()
        theView.highlightRecieved()
        
        if received.count == 0 {
            theView.emptyForRight()
            return
        }
        updateDataProvider(received)
    }
    
    func sentPicked() {
        let sent                                    = managedObjectContext.fetchAllSentPlaces()
        theView.highlightSent()
        
        if sent.count == 0 {
            theView.emptyForLeft()
            return
        }
        updateDataProvider(sent)
    }
   
    // MARK: Duplicate
    func updateDataProvider(objects:[RemotePlace]) {
        theView.hideEmptyState()
        dataProvider                                = DefaultDataProvider(items:objects, delegate :self)
        dataSource                                  = TableViewDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate                 = self
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mcs                               = segue.destinationViewController as? ManagedObjectContextSettable else { fatalError("DestinationViewController \(segue.destinationViewController.self) is not ManagedObjectContextSettable") }
        mcs.managedObjectContext                    = managedObjectContext
        
        switch segueIdentifierForSegue(segue) {
        case .PushToPlace:
            guard let vc = mcs as? PlaceViewController else {
                fatalError("DestinationViewController \(segue.destinationViewController.self) is not PlaceViewController")
            }
            guard let rps = remotePlaceSelected else { fatalError("Contact selected with out remotePlaceSelected") }
            vc.remotePlace = rps
        }
    }

}

extension PlacesViewController : UITableViewDelegate {
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = dataProvider.objectAtIndexPath(indexPath)
        remotePlaceSelected = place
        
        performSegue(.PushToPlace)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlaceTableViewCellHeight
    }
    
}

extension PlacesViewController : DataProviderDelegate {
    func dataProviderDidUpdate(updates:[DataProviderUpdate<RemotePlace>]?) {
    }
}

extension PlacesViewController : DataSourceDelegate {
    func cellIdentifierForObject(object:RemotePlace) -> String {
        return PlaceTableViewCell.Identifier
    }
}
