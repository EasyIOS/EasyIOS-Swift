//
//  EZExtend+String.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
// MARK: - String

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    var MD5 :  String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String(format: hash as String)
    }
}
