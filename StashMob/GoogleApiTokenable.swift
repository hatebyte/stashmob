//
//  GoogleKeys.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

extension NSBundle {
    
    public func stringValue(key:String)->String {
        guard let cid = objectForInfoDictionaryKey(key) as? String else { fatalError("There is no value for key : \(key)") }
        return cid
    }
    
}

public protocol GoogleApiTokenable {
    var googleMapsKey:String { get }
    var googlePlacesKey:String { get }
}

extension NSBundle:GoogleApiTokenable {
    
    public var googleMapsKey:String {
        return stringValue("GoogleMapsApiKey")
    }
    
    public var googlePlacesKey:String {
        return stringValue("GooglePlacesApiKey")
    }
    
}

public protocol DeepLinkable {
    var deepLinkUrl:String { get }
}

extension NSBundle:DeepLinkable {
    
    public var deepLinkUrl:String {
        return stringValue("UrlScheme")
    }
    
}