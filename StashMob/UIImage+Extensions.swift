//
//  UIImage+Extensions.swift
//  StashMob
//
//  Created by Scott Jones on 8/21/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

extension UIImage {

    static func generatePinImage(rawImage:UIImage)->UIImage {
        let imageRad:CGFloat            = 20.0
        let endRad:CGFloat              = 22.0
        let wRad:CGFloat                = 23.0
        let rect                        = CGSizeMake(wRad, wRad)
        
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0)
        let ctx                         = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.2)
        CGContextFillEllipseInRect(ctx, CGRectMake(0, 1, wRad, wRad - 1))
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0)
        CGContextFillEllipseInRect(ctx, CGRectMake(1, 1, endRad, endRad))
        CGContextTranslateCTM(ctx, 0.0, wRad)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextAddArc(ctx, wRad / 2, wRad / 2 - 0.25, imageRad / 2, 0, CGFloat(2.0 * M_PI), 0)
        CGContextClosePath(ctx)
        CGContextSaveGState(ctx)
        CGContextClip(ctx)
        CGContextDrawImage(ctx, CGRectMake(0, 0, wRad, wRad), rawImage.CGImage)
        CGContextRestoreGState(ctx)
        
        let imageRef                    = CGBitmapContextCreateImage(ctx)
        let newImage                    = UIImage(CGImage:imageRef!, scale:2.0, orientation:.Up)
        return newImage
    }
    
    static func circleImage(data:NSData)->UIImage {
        objc_sync_enter(self)
        let cImage                      = UIImage.generatePinImage(UIImage(data: data)!)
        objc_sync_exit(self)
        return cImage
    }
    
}