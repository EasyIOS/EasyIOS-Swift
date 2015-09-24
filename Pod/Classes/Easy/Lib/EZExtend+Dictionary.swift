//
//  Dictionary+EZExtend.swift
//  medical
//
//  Created by zhuchao on 15/4/25.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

extension Dictionary {
    
    //join the Dictionary with "&" to a url path
    var joinPath : String{
        var array = ArraySlice<String>()
        for (key,value) in self {
           array.append("\(key)=\(value)")
        }
        return array.joinWithSeparator("&")
    }
}