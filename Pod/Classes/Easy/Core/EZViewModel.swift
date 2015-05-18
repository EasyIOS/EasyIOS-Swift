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
    public var dym:InternalDynamic<NSData>?
    
    public var value:NSData?{
        return self.dym?.value
    }
    
    public init(_ data:NSData) {
        self.dym = InternalDynamic<NSData>(data)
    }
}

public class EZString:NSObject {
    public var dym:InternalDynamic<String>?
    
    public var value:String?{
        return self.dym?.value
    }
    
    public init(_ str:String) {
        self.dym = InternalDynamic<String>(str)
    }
}

public class EZURL:NSObject {
    public var dym:InternalDynamic<NSURL?>?
    public var value:NSURL?{
        return self.dym?.value
    }
    public init(_ url:NSURL?) {
        self.dym = InternalDynamic<NSURL?>(url)
    }
}

public class EZAttributedString:NSObject {
    public var dym:InternalDynamic<NSAttributedString>?
    public var value:NSAttributedString?{
        return self.dym?.value
    }
    public init(_ str:NSAttributedString) {
        self.dym = InternalDynamic<NSAttributedString>(str)
    }
}

public class EZImage:NSObject {
    public var dym:InternalDynamic<UIImage?>?
    public var value:UIImage?{
        return self.dym?.value
    }
    public init(_ image:UIImage?) {
        self.dym = InternalDynamic<UIImage?>(image)
    }
}

public class EZColor:NSObject {
    public var dym:InternalDynamic<UIColor>?
    public var value:UIColor?{
        return self.dym?.value
    }
    public init(_ color:UIColor) {
        self.dym = InternalDynamic<UIColor>(color)
    }
}

public class EZBool:NSObject {
    public var dym:InternalDynamic<Bool>?
    public var value:Bool?{
        return self.dym?.value
    }
    public init(_ b:Bool) {
        self.dym = InternalDynamic<Bool>(b)
    }
}

public class EZFloat:NSObject {
    public var dym:InternalDynamic<CGFloat>?
    public var value:CGFloat?{
        return self.dym?.value
    }
    public init(_ fl:CGFloat) {
        self.dym = InternalDynamic<CGFloat>(fl)
    }
}

public class EZInt:NSObject {
    public var dym:InternalDynamic<Int>?
    public var value:Int?{
        return self.dym?.value
    }
    public init(_ i:Int) {
        self.dym = InternalDynamic<Int>(i)
    }
}

public class EZNumber:NSObject {
    public var dym:InternalDynamic<NSNumber>?
    public var value:NSNumber?{
        return self.dym?.value
    }
    public init(_ i:NSNumber) {
        self.dym = InternalDynamic<NSNumber>(i)
    }
}

public class EZViewModel:NSObject {
    public var model_properyies :Dictionary<String,AnyObject>{
        return self.listProperties()
    }
    
    public func model_hasKey(key:String) -> Bool{
        return contains(self.model_properyies.keys, key)
    }
}