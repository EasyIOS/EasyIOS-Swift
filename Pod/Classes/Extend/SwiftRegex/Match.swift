//
//  Match.swift
//  Cupertino
//
//  Created by William Kent on 2/19/15.
//  Copyright (c) 2015 William Kent. All rights reserved.
//

import Foundation

private func safeSubstring(whole: String, range: NSRange) -> String? {
    if range.location != NSNotFound && range.length != 0 {
        return (whole as NSString).substringWithRange(range)
    } else {
        return nil
    }
}

public struct RegexMatch {
    private let sourceString: String
    private let cocoaMatch: NSTextCheckingResult
    
    internal init(cocoaMatch: NSTextCheckingResult, inString source: String) {
        self.sourceString = source
        self.cocoaMatch = cocoaMatch
    }
    
    public var range: NSRange {
        get {
            return cocoaMatch.range
        }
    }
    
    public var entireMatch: String? {
        get {
            return safeSubstring(sourceString, range: cocoaMatch.range)
        }
    }
    
    public var subgroupCount: Int {
        get {
            return cocoaMatch.numberOfRanges - 1
        }
    }
    
    public func subgroupRangeAtIndex(index: Int) -> NSRange? {
        return cocoaMatch.rangeAtIndex(index + 1)
    }
    
    public func subgroupMatchAtIndex(index: Int) -> String? {
        let range = cocoaMatch.rangeAtIndex(index + 1)
        return safeSubstring(sourceString, range: range)
    }
}
