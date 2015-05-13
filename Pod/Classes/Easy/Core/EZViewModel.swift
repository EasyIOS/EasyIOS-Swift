//
//  EZViewModel.swift
//  medical
//
//  Created by zhuchao on 15/5/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

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
    public init(_ url:NSURL?) {
        self.dym = InternalDynamic<NSURL?>(url)
    }
}

public class EZAttributedString:NSObject {
    public var dym:InternalDynamic<NSAttributedString>?
    public init(_ str:NSAttributedString) {
        self.dym = InternalDynamic<NSAttributedString>(str)
    }
}

public class EZImage:NSObject {
    public var dym:InternalDynamic<UIImage?>?
    public init(_ image:UIImage?) {
        self.dym = InternalDynamic<UIImage?>(image)
    }
}

public class EZColor:NSObject {
    public var dym:InternalDynamic<UIColor>?
    public init(_ color:UIColor) {
        self.dym = InternalDynamic<UIColor>(color)
    }
}

public class EZBool:NSObject {
    public var dym:InternalDynamic<Bool>?
    public init(_ b:Bool) {
        self.dym = InternalDynamic<Bool>(b)
    }
}

public class EZFloat:NSObject {
    public var dym:InternalDynamic<CGFloat>?
    public init(_ fl:CGFloat) {
        self.dym = InternalDynamic<CGFloat>(fl)
    }
}

public class EZInt:NSObject {
    public var dym:InternalDynamic<Int>?
    public init(_ i:Int) {
        self.dym = InternalDynamic<Int>(i)
    }
}

public class EZNumber:NSObject {
    public var dym:InternalDynamic<NSNumber>?
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