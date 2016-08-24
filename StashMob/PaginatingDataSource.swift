//
//  PaginatingDataSource.swift
//  StashMob
//
//  Created by Scott Jones on 8/24/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

let LoadMoreIdentifier = "LoadMore"
public class PaginatingDataSource<Delegate: DataSourceDelegate, Data:DataProvider, Cell:UITableViewCell where Delegate.Object == Data.Object, Cell:ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UITableViewDataSource {
   
    var endReached              = false
    var numSections             = 0
    public required init(tableView:UITableView, dataProvider:Data, delegate:Delegate) {
        self.tableView          = tableView
        self.dataProvider       = dataProvider
        self.delegate           = delegate
        super.init()
        self.numSections        = self.dataProvider.numberOfSections()
        tableView.dataSource    = self
        tableView.reloadData()
    }
    
    public var selectedObject: Data.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    public func processUpdates(updates:[DataProviderUpdate<Data.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let object):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? Cell else { break }
                cell.configureForObject(object)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
        tableView.endUpdates()
    }
    
    
    private let tableView:UITableView
    private let dataProvider:Data
    private weak var delegate:Delegate!
    
    // MARK: UITableViewDataSource
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !endReached {
            return dataProvider.numberOfSections() + 1
        }
        return dataProvider.numberOfSections()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !endReached && section == numSections {
            return 1
        }
        return dataProvider.numberOfItemsInSection(section)
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !endReached && indexPath.section == numSections {
            let cell = UITableViewCell(style: .Default, reuseIdentifier:LoadMoreIdentifier)
            cell.textLabel?.text = "Loading ..."
            cell.textLabel?.textAlignment = .Center
            return cell
        }
        
        let object = dataProvider.objectAtIndexPath(indexPath)
        let identifier = delegate.cellIdentifierForObject(object)
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell else {
            fatalError("Unexpected cell type at \(indexPath) : \(tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath))")
        }
        cell.configureForObject(object)
        return cell
    }
    
}