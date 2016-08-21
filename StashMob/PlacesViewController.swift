//
//  PlacesViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData
import StashMobModel

class PlacesViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable {
    
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    private typealias Data = DefaultDataProvider<PlacesViewController>
    private var dataSource:TableViewDataSource<PlacesViewController, Data, PlaceTableViewCell>!
    private var dataProvider: Data!
   
    var theView:PlacesView {
        guard let v = view as? PlacesView else { fatalError("The view is not a PlacesView") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theView.didload()
        sentPicked()
        theView.highlightSent()
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
        theView.sentButton?.addTarget(self, action: #selector(sentPicked), forControlEvents: .TouchUpInside)
        theView.receivedButton?.addTarget(self, action: #selector(receivedPicked), forControlEvents: .TouchUpInside)
        theView.backButton?.addTarget(self, action: #selector(pop), forControlEvents: .TouchUpInside)
    }
    
    func removeHandlers() {
        theView.sentButton?.removeTarget(self, action: #selector(sentPicked), forControlEvents: .TouchUpInside)
        theView.receivedButton?.removeTarget(self, action: #selector(receivedPicked), forControlEvents: .TouchUpInside)
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
            theView.emptyForReceived()
            return
        }
        theView.hideEmptyState()
        dataProvider                                = DefaultDataProvider(items:received, delegate :self)
        dataSource                                  = TableViewDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate                 = self
    }
    
    func sentPicked() {
        let sent                                    = managedObjectContext.fetchAllSentPlaces()
        theView.highlightSent()
        
        if sent.count == 0 {
            theView.emptyForSent()
            return
        }
        theView.hideEmptyState()
        dataProvider                                = DefaultDataProvider(items:sent, delegate :self)
        dataSource                                  = TableViewDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate                 = self
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlacesViewController : UITableViewDelegate {
    
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
