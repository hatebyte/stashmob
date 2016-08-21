//
//  GMSPlace+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import GooglePlaces
import StashMobModel

extension GMSPlace {

    func toRemotePlace()->RemotePlace {
        return RemotePlace(
             placeId            : placeID
            ,name               : name
            ,address            : formattedAddress
            ,latitude           : coordinate.latitude
            ,longitude          : coordinate.longitude
            ,phoneNumber        : phoneNumber
            ,priceLevel         : priceLevel.rawValue
            ,rating             : rating
            ,status             : openNowStatus.rawValue
            ,types              : types
            ,websiteUrlString   : website?.absoluteString
        )
    }
    
}
