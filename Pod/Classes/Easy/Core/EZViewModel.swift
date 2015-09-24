//
//  EZViewModel.swift
//  medical
//
//  Created by zhuchao on 15/5/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

public class EZData:NSObject {
    public var dym:Observable<NSData>?
    
    public var value:NSData?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    
    public init(_ data:NSData) {
        self.dym = Observable<NSData>(data)
    }
}

public class EZString:NSObject {
    public var dym:Observable<String>?
    
    public var value:String?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    
    public init(_ str:String) {
        self.dym = Observable<String>(str)
    }
}

public class EZURL:NSObject {
    public var dym:Observable<NSURL?>?
    public var value:NSURL?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ url:NSURL?) {
        self.dym = Observable<NSURL?>(url)
    }
}

public class EZAttributedString:NSObject {
    public var dym:Observable<NSAttributedString>?
    public var value:NSAttributedString?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ str:NSAttributedString) {
        self.dym = Observable<NSAttributedString>(str)
    }
}

public class EZImage:NSObject {
    public var dym:Observable<UIImage?>?
    public var value:UIImage?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ image:UIImage?) {
        self.dym = Observable<UIImage?>(image)
    }
}

public class EZColor:NSObject {
    public var dym:Observable<UIColor>?
    public var value:UIColor?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ color:UIColor) {
        self.dym = Observable<UIColor>(color)
    }
}

public class EZBool:NSObject {
    public var dym:Observable<Bool>?
    public var value:Bool?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ b:Bool) {
        self.dym = Observable<Bool>(b)
    }
}

public class EZFloat:NSObject {
    public var dym:Observable<CGFloat>?
    public var value:CGFloat?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ fl:CGFloat) {
        self.dym = Observable<CGFloat>(fl)
    }
}

public class EZInt:NSObject {
    public var dym:Observable<Int>?
    public var value:Int?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ i:Int) {
        self.dym = Observable<Int>(i)
    }
}

public class EZNumber:NSObject {
    public var dym:Observable<NSNumber>?
    public var value:NSNumber?{
        get{
            return self.dym?.value
        }set(value){
            self.dym?.value = value!
        }
    }
    public init(_ i:NSNumber) {
        self.dym = Observable<NSNumber>(i)
    }
}

extension NSObject{
    public var model_properyies :Dictionary<String,AnyObject>{
        return self.listProperties()
    }
    
    public func model_hasKey(key:String) -> Bool{
        return self.model_properyies.keys.contains(key)
    }
}

public class EZViewModel:NSObject {

}