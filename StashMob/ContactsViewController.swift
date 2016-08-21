//
//  ContactsViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

import CoreData
import StashMobModel

class ContactsViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable {
    
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    private typealias Data = DefaultDataProvider<ContactsViewController>
    private var dataSource:TableViewDataSource<ContactsViewController, Data, ContactTableViewCell>!
    private var dataProvider: Data!
    
    var theView:TwoListViewable {
        guard let v = view as? TwoListViewable else { fatalError("The view is not a TwoListViewable") }
        return v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = theView as? ContactsView
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
        let received                                = managedObjectContext.fetchAllRecievedContacts()
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
        let sent                                    = managedObjectContext.fetchAllSentContacts()
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ContactsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ContactTableViewCellHeight
    }
    
}

extension ContactsViewController : DataProviderDelegate {
    func dataProviderDidUpdate(updates:[DataProviderUpdate<RemoteContact>]?) {
    }
}

extension ContactsViewController : DataSourceDelegate {
    func cellIdentifierForObject(object:RemoteContact) -> String {
        return ContactTableViewCell.Identifier
    }
}