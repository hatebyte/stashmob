//
//  GoogleMapsController.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class GMCenteredController:NSObject {
    
    var marker:GMSMarker?
    weak var mapView:GMSMapView!
    var coordinate:CLLocationCoordinate2D!
 
    init(mapView:GMSMapView, coordinate:CLLocationCoordinate2D, image:UIImage?) {
        self.mapView                        = mapView
        self.coordinate                     = coordinate
        super.init()
        setup(image)
    }
    
    deinit {
        clearPins()
    }
    
    private func clearPins() {
        marker?.map                         = nil
    }

    internal func setup(image:UIImage?) {
        mapView.mapType                     = kGMSTypeNormal
        marker                              = GMSMarker(position:self.coordinate)
        marker?.map                         = mapView
        marker?.icon                        = image
        marker?.appearAnimation             = kGMSMarkerAnimationPop;
        update()
    }
    
    func update() {
        mapView.animateWithCameraUpdate(GMSCameraUpdate.setTarget(self.coordinate, zoom:14))
    }
    
}