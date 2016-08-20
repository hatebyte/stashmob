//
//  AvatarSaver.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

import UIKit

extension NSFileManager {

    func saveImageNamed(name:String, ext:String, data:NSData) {
        let fileURL                                 = avatarDirURL().URLByAppendingPathComponent(name).URLByAppendingPathExtension(ext)
        print(fileURL)
        data.writeToURL(fileURL, atomically: true)
    }

    func getImageNamed(name:String, ext:String)->UIImage? {
        let fileURL                                 = avatarDirURL().URLByAppendingPathComponent(name).URLByAppendingPathExtension(ext)
        return UIImage(contentsOfFile: fileURL.path!)
    }
    
    func avatarDirURL()->NSURL {
        return NSURL.fileURLWithPath(NSFileManager.documents, isDirectory: true).URLByAppendingPathComponent("avatars")
    }
    
    public static var documents:String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
 
}