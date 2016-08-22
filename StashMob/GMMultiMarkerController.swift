//
//  CMMultiMarkerController.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import StashMobModel

class GMMultiMarkerController:NSObject {
    
    var sentMarkers:[GMSMarker]         = []
    var receivedMarkers:[GMSMarker]     = []
    weak var mapView:GMSMapView!
    
    init(mapView:GMSMapView) {
        self.mapView                        = mapView
        super.init()
        setup()
    }
    
    internal func setup() {
        mapView.mapType                     = kGMSTypeNormal
    }
   
    private func clearPins() {
        for m in sentMarkers {
            m.map                           = nil
        }
        for m in receivedMarkers {
            m.map                           = nil
        }
        sentMarkers                         = []
        receivedMarkers                     = []
    }
    
    func update(sent:[PersonAndPlaces], received:[PersonAndPlaces]) {
        clearPins()
        var bounds                          = GMSCoordinateBounds()
        for s in sent {
            for p in s.places {
                let marker                  = GMSMarker(position: p.coordinate)
                marker.map                  = mapView
                marker.icon                 = UIImage(named:"event_pin")
                marker.groundAnchor         = CGPointMake(0.5, 0.5);
                bounds                      = bounds.includingCoordinate(marker.position)
                sentMarkers.append(marker)
            }
        }
        for s in received {
            for p in s.places {
                let marker                  = GMSMarker(position: p.coordinate)
                marker.map                  = mapView
                marker.icon                 = s.person.getPinImage()
                marker.groundAnchor         = CGPointMake(0.5, 0.5);
                bounds                      = bounds.includingCoordinate(marker.position)
                receivedMarkers.append(marker)
            }
        }
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withEdgeInsets:UIEdgeInsetsMake(40, 60, 40, 60)))
    }
    
}