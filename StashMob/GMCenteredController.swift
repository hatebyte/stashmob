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
    var image:UIImage?
    var coordinate:CLLocationCoordinate2D!
    weak var mapView:GMSMapView!
    
    init(mapView:GMSMapView, coordinate:CLLocationCoordinate2D, image:UIImage?) {
        self.mapView                        = mapView
        self.image                          = image
        self.coordinate                     = coordinate
        super.init()
        setup()
    }
    
    internal func setup() {
        mapView.mapType                    = kGMSTypeNormal
        update()
    }
    
    func update() {
        marker                              = GMSMarker(position:self.coordinate)
        marker?.map                         = mapView
        marker?.icon                        = image
        marker?.appearAnimation             = kGMSMarkerAnimationPop;
        mapView.animateWithCameraUpdate(GMSCameraUpdate.setTarget(self.coordinate, zoom:14))
    }
    
}