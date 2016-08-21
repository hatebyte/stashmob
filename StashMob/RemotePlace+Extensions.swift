
//
//  RemotePlace+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import StashMobModel
import CoreLocation

struct PlaceFeature {
    let key:String
    let value:String
}

enum PlaceKeys {
    case kName
    case kPlaceId
    case kAddress
    case kCoordinates
    case kPhoneNumber
    case kPriceLevel
    case kRating
    case kStatus
    case kTypes
    case kWebsite
}
extension PlaceKeys {
    var localizedString:String {
        switch self {
        case kName : return NSLocalizedString("Name", comment:"Place Feature Key : name")
        case kPlaceId : return NSLocalizedString("ID", comment:"Place Feature Key : placeId")
        case kAddress : return NSLocalizedString("Address", comment:"Place Feature Key : address")
        case kCoordinates : return NSLocalizedString("Coordinates", comment:"Place Feature Key : coordinates")
        case kPhoneNumber : return NSLocalizedString("PhoneNumber", comment:"Place Feature Key : phoneNumber")
        case kPriceLevel : return NSLocalizedString("PriceLevel", comment:"Place Feature Key : priceLevel")
        case kRating : return NSLocalizedString("Rating", comment:"Place Feature Key : rating")
        case kStatus : return NSLocalizedString("Status", comment:"Place Feature Key : status")
        case kTypes : return NSLocalizedString("Types", comment:"Place Feature Key : types")
        case kWebsite : return NSLocalizedString("Website", comment:"Place Feature Key : website")
        }
    }
}


public enum OpenStatus : Int {
    case Yes
    case No
    case Unknown
}
extension OpenStatus {
    var localizedString:String {
        switch self {
        case Yes : return NSLocalizedString("Open Now", comment:"OpenStatus: yes")
        case No : return NSLocalizedString("Closed", comment:"OpenStatus : no")
        case Unknown : return NSLocalizedString("Don't Know", comment:"OpenStatus : unknown")
        }
    }
}

public enum PriceLevel : Int {
    case Unknown
    case Free
    case Cheap
    case Medium
    case High
    case Expensive
}
extension PriceLevel {
    var localizedString:String {
        switch self {
        case Unknown : return NSLocalizedString("Unknown", comment:"PriceLevel: Unknown")
        case Free : return NSLocalizedString("Free", comment:"PriceLevel: Free")
        case Cheap : return NSLocalizedString("Cheap", comment:"PriceLevel: Cheap")
        case Medium : return NSLocalizedString("Medium", comment:"PriceLevel: Medium")
        case High : return NSLocalizedString("High", comment:"PriceLevel: High")
        case Expensive : return NSLocalizedString("Expensive", comment:"PriceLevel: Expensive")
        }
    }
}

extension RemotePlace {
    
    var coordinate:CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var tableData:[PlaceFeature] {
        var stat = OpenStatus.Unknown
        var pl = PriceLevel.Unknown
        if let s = OpenStatus(rawValue:status) { stat =  s }
        if let p = PriceLevel(rawValue:priceLevel ?? 0) { pl =  p }
        return [
             PlaceFeature(key:PlaceKeys.kPlaceId.localizedString, value:placeId)
            ,PlaceFeature(key:PlaceKeys.kAddress.localizedString, value:address ?? "")
            ,PlaceFeature(key:PlaceKeys.kCoordinates.localizedString, value:"\(latitude),\(longitude)")
            ,PlaceFeature(key:PlaceKeys.kPhoneNumber.localizedString, value:phoneNumber ?? "")
            ,PlaceFeature(key:PlaceKeys.kPriceLevel.localizedString, value:pl.localizedString)
            ,PlaceFeature(key:PlaceKeys.kRating.localizedString, value:"\(rating)")
            ,PlaceFeature(key:PlaceKeys.kStatus.localizedString, value:stat.localizedString)
            ,PlaceFeature(key:PlaceKeys.kTypes.localizedString, value:types.joinWithSeparator(","))
            ,PlaceFeature(key:PlaceKeys.kWebsite.localizedString, value:websiteUrlString ?? "")
        ]
    }

}
    