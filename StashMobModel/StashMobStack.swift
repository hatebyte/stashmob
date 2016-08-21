//
//  StashMobStack.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import CoreData

private let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("StashLocModel.currentmodel")

public func createMainContext(progress: NSProgress? = nil, migrationCompletion: NSManagedObjectContext -> () = { _ in }) -> NSManagedObjectContext? {
    let version = StashMobModelVersion(storeURL: StoreURL)
    Place.registerBinaryStringableTransformers()
    
    guard version == nil || version == StashMobModelVersion.CurrentVersion else {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType, modelVersion: StashMobModelVersion.CurrentVersion, storeURL: StoreURL, progress: progress)
            dispatch_async(dispatch_get_main_queue()) {
                migrationCompletion(context)
            }
        }
        return nil
    }
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType, modelVersion: StashMobModelVersion.CurrentVersion, storeURL: StoreURL)
    context.mergePolicy = NSMergePolicy(mergeType: .MergeByPropertyStoreTrumpMergePolicyType)
    return context
}