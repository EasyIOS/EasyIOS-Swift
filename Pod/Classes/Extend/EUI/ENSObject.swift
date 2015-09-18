//
//  ENSObject.swift
//  Pods
//
//  Created by zhuchao on 15/7/21.
//
//

import Foundation
import JavaScriptCore

@objc public protocol ENSObject:JSExport{
    optional func val(keyPath:String) -> AnyObject?
    optional func attr(keyPath:String,_ value:AnyObject?)
    optional func attrs(dict:[NSObject : AnyObject]!)
    optional func call(selector:String)
    optional func call(selector:String,withObject object:AnyObject?)
}

public extension NSObject{
    
    public func call(selector:String){
        NSThread.detachNewThreadSelector(Selector(selector), toTarget:self, withObject: nil)
    }
    
    public func call(selector:String,withObject object:AnyObject?){
        NSThread.detachNewThreadSelector(Selector(selector), toTarget:self, withObject: object)
    }
    
    public func attr(key:String,_ value:AnyObject?) {
        
//        do {
//            try {
//                if let str = value as? String {
//                    self.setValue(str.anyValue(key.toKeyPath), forKeyPath: key.toKeyPath)
//                }else{
//                    self.setValue(value, forKeyPath: key.toKeyPath)
//                }
//            }
//        } catch {
//          println("JS Error:")
//        }
        SwiftTryCatch.dotry({
            if let str = value as? String {
                self.setValue(str.anyValue(key.toKeyPath), forKeyPath: key.toKeyPath)
            }else{
                self.setValue(value, forKeyPath: key.toKeyPath)
            }
        }, getCatch: { (error) in
            print("JS Error:\(error.description)")
        }, finally: nil)
    }
    
    public func attrs(dict:[String : AnyObject]!){
        
//        do {
//            try self.setValuesForKeysWithDictionary(dict)
//        } catch {
//            print("JS Error:")
//        }
        
        SwiftTryCatch.dotry({
            self.setValuesForKeysWithDictionary(dict)
        }, getCatch: { (error) in
            print("JS Error:\(error.description)")
        }, finally: nil)
    }
    
    public func val(key:String) -> AnyObject? {
        var result:AnyObject?
        
//        
//        do {
//            try result = self.valueForKeyPath(key.toKeyPath)
//        } catch {
//            print("JS Error:")
//        }
        
        
        SwiftTryCatch.dotry({
            result = self.valueForKeyPath(key.toKeyPath)
            }, getCatch: { (error) in
                print("JS Error:\(error.description)")
            }, finally: nil)
        return result
    }
}

@objc public protocol EZActionJSExport:JSExport{
    static func SEND_IQ_CACHE (req:EZRequest)
    static func SEND_CACHE (req:EZRequest)
    static func SEND (req:EZRequest)
    static func Upload (req:EZRequest)
    static func Download (req:EZRequest)
}
