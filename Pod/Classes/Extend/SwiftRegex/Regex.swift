//
//  Regex.swift
//  Cupertino
//
//  Created by William Kent on 2/19/15.
//  Copyright (c) 2015 William Kent. All rights reserved.
//

import Foundation

private func convertRange(range: NSRange, relativeToString string: String) -> Range<String.Index> {
    let start = string.startIndex.advancedBy(range.location)
    let end = string.startIndex.advancedBy(NSMaxRange(range))
    return Range(start: start, end: end)
}

public enum RegexFlags {
    case CaseInsensitive
    case AllowCommentsAndWhitespace
    case IgnoreMetacharacters
    case DotMatchesLineSeparators
    case AnchorsMatchLines
    case UseUnicodeWordBoundaries
}

public struct Regex {
    public let pattern: String
    public var options: Set<RegexFlags>
    
    public init(_ pattern: String, options: Set<RegexFlags>) {
        self.pattern = pattern
        self.options = options
    }
    
    public init(_ pattern: String) {
        self.pattern = pattern
        self.options = []
    }
    
    private var matcherOptions: NSRegularExpressionOptions {
        get {
            var opts: NSRegularExpressionOptions = NSRegularExpressionOptions.CaseInsensitive
            
            if options.contains(.CaseInsensitive) {
                opts = NSRegularExpressionOptions.CaseInsensitive
            }
            if options.contains(.AllowCommentsAndWhitespace) {
                opts = NSRegularExpressionOptions.AllowCommentsAndWhitespace
            }
            if options.contains(.IgnoreMetacharacters) {
                opts = NSRegularExpressionOptions.IgnoreMetacharacters
            }
            if options.contains(.DotMatchesLineSeparators) {
                opts = NSRegularExpressionOptions.DotMatchesLineSeparators
            }
            if options.contains(.AnchorsMatchLines) {
                opts = NSRegularExpressionOptions.AnchorsMatchLines
            }
            if options.contains(.UseUnicodeWordBoundaries) {
                opts = NSRegularExpressionOptions.UseUnicodeWordBoundaries
            }
            
            return opts
        }
    }
    
    private var matcher: NSRegularExpression? {
        get {
            return try? NSRegularExpression(pattern: self.pattern, options: self.matcherOptions)
        }
    }
    
    public func test(string: String) -> Bool? {
        return test(string, options: [])
    }
    
    public func test(string: String, options: NSMatchingOptions) -> Bool? {
        // This function returns true if the regex matches, false if the regex does
        // not match, or nil if there is a syntax error in the regex itself.
        if let matcher = matcher {
            return matcher.numberOfMatchesInString(string, options: options, range: NSMakeRange(0, string.characters.count)) != 0
        } else {
            return nil
        }
    }
    
    public func match(string: String) -> [RegexMatch]? {
        return match(string, options: [])
    }
    
    public func match(string: String, options: NSMatchingOptions) -> [RegexMatch]? {
        if let matcher = matcher {
            let cocoaMatches = matcher.matchesInString(string, options: options, range: NSMakeRange(0, string.characters.count))
            var retval = [RegexMatch]()
            
            for match: AnyObject in cocoaMatches {
                if let match = match as? NSTextCheckingResult {
                    retval.append(RegexMatch(cocoaMatch: match, inString: string))
                }
            }
            
            return retval
        } else {
            return nil
        }
    }
    
    public func match(string: String, options: NSMatchingOptions, startPosition: Int) -> [RegexMatch]? {
        if let matcher = matcher {
            let cocoaMatches = matcher.matchesInString(string, options: options, range: NSMakeRange(startPosition, string.characters.count - startPosition))
            var retval = [RegexMatch]()
            
            for match: AnyObject in cocoaMatches {
                if let match = match as? NSTextCheckingResult {
                    retval.append(RegexMatch(cocoaMatch: match, inString: string))
                }
            }
            
            return retval
        } else {
            return nil
        }
    }
    
    public func replace(string: String, withTemplate template: String) -> String? {
        return replace(string, options: [], withTemplate: template)
    }
    
    public func replace(string: String, options: NSMatchingOptions, withTemplate template: String) -> String? {
        if let matcher = matcher {
            let workString = NSMutableString(string: string)
            matcher.replaceMatchesInString(workString, options: options, range: NSMakeRange(0, workString.length), withTemplate: template)
            let retval = workString as NSString
            return String(retval)
        }
        
        return nil
    }
    
    public func replace(string: String, withBlock block: (RegexMatch) -> String) -> String? {
        return replace(string, options: [], withBlock: block)
    }
    
    public func replace(string: String, options: NSMatchingOptions, withBlock block: (RegexMatch) -> String) -> String? {
        if let matches = match(string, options: options) {
            var replacements: [(NSRange, String)] = []
            
            for match in matches {
                let replacedSubstring = block(match)
                replacements.append((match.range, replacedSubstring))
            }
            
            // Sort the replacements in order of location, then reverse it.
            // By applying the replacements in right-to-left order, I avoid having
            // to recalculate all the indices when a replacement changes the length
            // of the replaced substring.
            replacements.sortInPlace({
                (lhs, rhs) -> Bool in
                let (leftRange, _) = lhs
                let (rightRange, _) = rhs
                
                return leftRange.location < rightRange.location
            })
            replacements = Array(replacements.reverse())
            
            var retval = string
            for pair in replacements {
                let (range, substring) = pair
                retval.replaceRange(convertRange(range, relativeToString: retval), with: substring)
            }
            
            return retval
        } else {
            return nil
        }
    }
}

extension Regex: StringLiteralConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = UnicodeScalar
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.pattern = "\(value)"
        self.options = []
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.pattern = value
        self.options = []
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.pattern = value
        self.options = []
    }
}
