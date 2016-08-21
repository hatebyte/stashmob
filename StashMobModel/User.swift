//
//  User.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData


public class User: ManagedObject {

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String?

}

extension User : ManagedObjectType {
    
    public static var entityName: String {
        return "User"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var defaultPredicate: NSPredicate {
        return NSPredicate(value: true)
    }
    
}

private let LoggedInUserCacheKey            = "com.hatebyte.stashmob.ios.loggedinuserkey"
extension User: UserLoggable {

    @NSManaged public var isLoggedIn:Bool

    public static func loggedInUser(moc:NSManagedObjectContext)->User? {
        let user = User.fetchSingleObjectInContext(moc, cacheKey:LoggedInUserCacheKey) { request in
            request.predicate       = loggedInPredicate
        }
        guard let u = user else {
            return nil
        }
        return u
    }
    
}