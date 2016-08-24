//
//  ContactsViewController.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, ManagedObjectContextSettable, ManagedContactable,SegueHandlerType {
    
    weak var managedObjectContext: NSManagedObjectContext!
    weak var contactManager: Contactable!
    
    private typealias Data = FetchedResultsDataViewModelProvider<ContactsViewController, Contact>
//    private typealias Data = DefaultDataProvider<ContactsViewController>
    var pageCount = 40
    var page = 1
    
    private var dataSource:PaginatingDataSource<ContactsViewController, Data, ContactTableViewCell>!
    private var dataProvider: Data!
   
    var remoteContactSelected:RemoteContact?
    
    enum SegueIdentifier:String {
        case PushToContact                         = "pushToContact"
    }
    
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
        page = 1
        let count                                   = managedObjectContext.fetchRecievedContactsCount()
        theView.highlightRecieved()
        
        if count == 0 {
            theView.emptyForLeft()
            return
        }
        let request                                 = NSFetchRequest(entityName: Contact.entityName)
        request.predicate                           = Contact.allReceivedContactsPredicate
        request.returnsObjectsAsFaults              = true
        request.fetchLimit                          = page * pageCount
        request.sortDescriptors                     = [NSSortDescriptor(key:"createdAt", ascending:true)]
        
        updateDataProvider(request)
    }
    
    func sentPicked() {
        page = 1
        let count                                   = managedObjectContext.fetchSentContactsCount()
        theView.highlightSent()

        if count == 0 {
            theView.emptyForLeft()
            return
        }
        let request                                 = NSFetchRequest(entityName: Contact.entityName)
        request.predicate                           = Contact.allSentContactsPredicate
        request.returnsObjectsAsFaults              = true
        request.fetchLimit                          = page * pageCount
        request.sortDescriptors                     = [NSSortDescriptor(key:"createdAt", ascending:true)]
       
        updateDataProvider(request)
    }
   
    // MARK: Duplicate
    func updateDataProvider(request:NSFetchRequest) {
        theView.hideEmptyState()
        let frc                                     = NSFetchedResultsController(
            fetchRequest:request
            ,managedObjectContext:managedObjectContext
            ,sectionNameKeyPath:nil
            ,cacheName:nil
        )
        dataProvider                                = FetchedResultsDataViewModelProvider(fetchedResultsController:frc, delegate:self)
        dataSource                                  = PaginatingDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate                 = self
    }

    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mcs                               = segue.destinationViewController as? ManagedObjectContextSettable else { fatalError("DestinationViewController \(segue.destinationViewController.self) is not ManagedObjectContextSettable") }
        mcs.managedObjectContext                    = managedObjectContext
        
        switch segueIdentifierForSegue(segue) {
        case .PushToContact:
            guard let vc = mcs as? ContactViewController else {
                fatalError("DestinationViewController \(segue.destinationViewController.self) is not ContactViewController")
            }
            guard let rcs = remoteContactSelected else { fatalError("Contact selected with out remoteContactSelected") }
            vc.remoteContact = rcs
        }
    }
    
    func loadMore() {
        let count                                   = managedObjectContext.fetchSentContactsCount()
        let limit                                   = page * pageCount
        if limit < count {
            dataSource.endReached                   = false
            page                                    = page + 1
            dataProvider.reconfigureFetchRequest { request in
                request.fetchLimit                  = page * pageCount
            }
        } else {
            dataSource.endReached                   = true
            theView.tableView?.reloadData()
        }
    }
    
}

extension ContactsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact                         = dataProvider.objectAtIndexPath(indexPath)
        remoteContactSelected = contact
        performSegue(.PushToContact)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ContactTableViewCellHeight
    }
 
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex            = tableView.numberOfSections - 1;
        let lastRowIndex                = tableView.numberOfRowsInSection(lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            loadMore()
        }
    }
    
}

extension ContactsViewController : DataProviderDelegate {
    func dataProviderDidUpdate(updates:[DataProviderUpdate<RemoteContact>]?) {
        dataSource.processUpdates(updates)
    }
}

extension ContactsViewController : DataSourceDelegate {
    func cellIdentifierForObject(object:RemoteContact) -> String {
        return ContactTableViewCell.Identifier
    }
}