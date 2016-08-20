//
//  UserLoggable.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData

private let UserLoggedInKey             = "isLoggedIn"

public protocol UserLoggable: class {
    associatedtype Element
    var isLoggedIn:Bool { get set }
    
    func setAsLoggedInUser()
//    func logOut()
    
    static func loggedInUser(moc:NSManagedObjectContext)->Element?
    static var loggedInPredicate:NSPredicate { get }
    
}

extension UserLoggable where Self:User  {
    
    public func setAsLoggedInUser() {
        isLoggedIn          = true
    }
    
    static public var loggedInPredicate:NSPredicate {
        return NSPredicate(format: "%K == true", UserLoggedInKey)
    }
    
}

