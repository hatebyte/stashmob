//
//  ContactProtocol.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

protocol ContactProtocol {
    func contactForPhoneNumber()->RemoteContact?
    func whoVisitedLocation(locationId:String)->[RemoteContact]
}