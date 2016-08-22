//
//  AvatarSaver.swift
//  StashMob
//
//  Created by Scott Jones on 8/20/16.
//  Copyright © 2016 Scott Jones. All rights reserved.
//

import Foundation

import UIKit

let AvatarPath                  = "avatars"
let Pins                        = "pins"

extension NSFileManager {

//    func saveImageNamed(name:String, ext:String, data:NSData) {
//        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("avatar")
//        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("customDirectory")
//        if !fileExistsAtPath(paths){
//            try! createDirectoryAtPath(paths, withIntermediateDirectories: true, attributes: nil)
//            print("Already dictionary created.")
//        }
//
//        data.writeToFile((paths as NSString).stringByAppendingPathComponent("\(name).\(ext)"), atomically:true)
//        
//    }
//    
//    func getImageNamed(name:String, ext:String)->UIImage? {
//        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("avatar")
//        return UIImage(contentsOfFile: (paths as NSString).stringByAppendingPathComponent("\(name).\(ext)"))
//    }

    func saveImageNamed(name:String, ext:String, data:NSData) {
        saveImage(NSFileManager.avatarPath, name:name, ext:ext, data:data)
    }

    func getImageNamed(name:String, ext:String)->UIImage? {
        return getImage(NSFileManager.avatarPath, name:name, ext:ext)
    }
    
    func savePinImageNamed(name:String, ext:String, data:NSData) {
        saveImage(NSFileManager.pinPath, name:name, ext:ext, data:data)
    }
    
    func getPinImageNamed(name:String, ext:String)->UIImage? {
        return getImage(NSFileManager.pinPath, name:name, ext:ext)
    }
    
    static var avatarPath:String {
        return (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(AvatarPath)
    }
    
    static var pinPath:String {
        return (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(Pins)
    }
    
    func getImage(path:String, name:String, ext:String)->UIImage? {
        let imagePAth = (path as NSString).stringByAppendingPathComponent("\(name).\(ext)")
        return UIImage(contentsOfFile: imagePAth)
    }
    
    func saveImage(path:String, name:String, ext:String, data:NSData) {
        if !fileExistsAtPath(path){
            try! createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
        let imagePAth = (path as NSString).stringByAppendingPathComponent("\(name).\(ext)")
        data.writeToFile(imagePAth, atomically:true)
    }

}