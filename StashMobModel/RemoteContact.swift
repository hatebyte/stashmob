//
//  RemoteContact.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

public struct RemoteContact {
    
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var email: String?
    
    public init(phoneNumber: String?, email:String?, firstName: String?, lastName: String?) {
        self.phoneNumber    = phoneNumber
        self.firstName      = firstName
        self.lastName       = lastName
        self.email          = email
    }
    
}

extension RemoteContact {
    
    public init(managedContact : Contact ){
        self.phoneNumber    = managedContact.phoneNumber
        self.firstName      = managedContact.firstName
        self.lastName       = managedContact.lastName
        self.email          = managedContact.email
    }
    
}