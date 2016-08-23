//
//  CoreDataTestUtilities.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData
@testable import StashMob

extension dispatch_group_t {
    func spinUntilEmpty() {
        var done = false
        dispatch_group_notify(self, dispatch_get_main_queue()) {
            done = true
        }
        repeat {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.0001))
        } while !done
    }
}

func waitForManagedObjectContextToBeDone(moc:NSManagedObjectContext) {
    let group = dispatch_group_create()!
    dispatch_group_enter(group)
    moc.performBlock {
        dispatch_group_leave(group)
    }
    group.spinUntilEmpty()
}


private let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("StashLocModel.currentmodel")

extension NSManagedObjectContext {
    
    static func firstLaunchContext()->NSManagedObjectContext {
        return testContext(.MainQueueConcurrencyType) { $0.addMemoryTestStore() }
    }
    
    static func inMemoryContext()->NSManagedObjectContext {
        return testContext(.PrivateQueueConcurrencyType) { $0.addMemoryTestStore() }
    }
    
    static func testableSqliteContext()->NSManagedObjectContext {
        return testContext(.PrivateQueueConcurrencyType) { $0.addSqliteTestStore(StoreURL) }
    }
    
    static func testContext(concurrencyType: NSManagedObjectContextConcurrencyType, addStore:NSPersistentStoreCoordinator ->()) ->NSManagedObjectContext {

        Place.registerBinaryStringableTransformers()
        
        let model = StashMobModelVersion.CurrentVersion.managedObjectModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        addStore(coordinator)
        let context = NSManagedObjectContext(concurrencyType:concurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
    func destroyTestSqliteContext() {
        reset()
        guard let psc = persistentStoreCoordinator else { return }
        for store in psc.persistentStores {
            try! psc.removePersistentStore(store)
        }
    }
    
    func removeTestStore() {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(StoreURL)
        } catch let error {
            print("Removing StoreURL : \(StoreURL)\nError : \(error)")
        }
    }
    
}

extension NSPersistentStoreCoordinator {
    func addMemoryTestStore(){
        try! addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
    }
    func addSqliteTestStore(storeURL:NSURL){
        try! addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:storeURL, options: nil)
    }
}

