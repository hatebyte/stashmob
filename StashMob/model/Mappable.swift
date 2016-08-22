//
//  Mappable.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData

public protocol RemoteMappable {
    func mapTo<T:ManagedObjectType>(managedObject:T)
}

