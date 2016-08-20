//
//  PlaceAndPerson.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel

struct PersonAndPlaces{
    let places:[RemotePlace]
    let person:RemoteContact

    init(person:RemoteContact, places:[RemotePlace]) {
        self.person = person
        self.places = places
    }
}
