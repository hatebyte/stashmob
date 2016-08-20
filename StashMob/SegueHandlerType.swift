//
//  SegueHandlerType.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import UIKit

public protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier else { fatalError("Unknown segue: \(segue))") }
        return segueForIdentifier(identifier)
    }
    
    public func segueForIdentifier(identifier: String) -> SegueIdentifier {
        guard let segue = SegueIdentifier(rawValue: identifier)
            else { fatalError("Unknown segue for identifier: \(identifier))") }
        return segue
    }
    
    public func performSegue(segueIdentifier: SegueIdentifier) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: nil)
    }
    
}