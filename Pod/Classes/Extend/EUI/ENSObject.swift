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
    func val(keyPath:String) -> AnyObject?
    func attr(keyPath:String,_ value:AnyObject?)
    func attrs(dict:[NSObject : AnyObject]!)
    func call(selector:String)
    func call(selector:String,withObject object:AnyObject?)
}

public extension NSObject{
    
    public func call(selector:String){
        NSThread.detachNewThreadSelector(Selector(selector), toTarget:self, withObject: nil)
    }
    
    public func call(selector:String,withObject object:AnyObject?){
        NSThread.detachNewThreadSelector(Selector(selector), toTarget:self, withObject: object)
    }
    
    public func attr(key:String,_ value:AnyObject?) {
        SwiftTryCatch.`try`({
            if let str = value as? String {
                self.setValue(str.anyValue(key.toKeyPath), forKeyPath: key.toKeyPath)
            }else{
                self.setValue(value, forKeyPath: key.toKeyPath)
            }
        }, `catch`: { (error) in
            print("JS Error:\(error.description)")
        }, finally: nil)
    }
    
    public func attrs(var dict:[String : AnyObject]!){
        SwiftTryCatch.`try`({
            for (key, value) in dict {
                if let str = value as? String {
                    dict[key.toKeyPath] = str.anyValue(key.toKeyPath)
                }
            }
            self.setValuesForKeysWithDictionary(dict)
        }, `catch`: { (error) in
            print("JS Error:\(error.description)")
        }, finally: nil)
    }
    
    public func val(key:String) -> AnyObject? {
        var result:AnyObject?
        SwiftTryCatch.`try`({
            result = self.valueForKeyPath(key.toKeyPath)
            }, `catch`: { (error) in
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
