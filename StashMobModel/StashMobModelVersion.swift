//
//  StashMobModelVersion.swift
//  StashMob
//
//  Created by Scott Jones on 8/19/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import CoreData

enum StashMobModelVersion : String {
    case Version1 = "StashMob"
}

extension StashMobModelVersion:ModelVersionType {
    static var AllVersions: [StashMobModelVersion] { return [.Version1] }
    static var CurrentVersion: StashMobModelVersion { return .Version1 }
    
    var name: String { return rawValue }
    var modelBundle: NSBundle { return NSBundle(forClass: Place.self) }
    var modelDirectoryName: String { return "StashMob.momd" }
}

