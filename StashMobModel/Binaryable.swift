//
//  Binaryable.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation
import CoreData

public protocol BinaryStringArrayTransformable {}

private var transformerStringArrayRegistrationToken: dispatch_once_t    = 0
private let StringArrayTransformerName                                  = "StringArrayTransformerName"

typealias StringArray                                                   = [String]
extension BinaryStringArrayTransformable where Self:ManagedObject {
    
    static func registerBinaryStringableTransformers() {
        dispatch_once(&transformerStringArrayRegistrationToken) {
            ValueTransformer.registerTransformerWithName(StringArrayTransformerName, transform: { sArray in
                guard let sarr = sArray else { return nil }
                return NSKeyedArchiver.archivedDataWithRootObject(sarr)
                }, reverseTransform: { (data: NSData?) -> NSArray? in
                    guard let sarr = data else { return nil }
                    return NSKeyedUnarchiver.unarchiveObjectWithData(sarr) as? StringArray
            })
        }
    }
    
}