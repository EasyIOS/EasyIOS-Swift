//
//  EZExtend+String.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
// MARK: - String

public func trimToArray (str:String) -> Array<String>{
    return str.trim.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter(){
        return !isEmpty($0)
    }
}

public func trimToArrayBy (str:String,by:String) -> Array<String>{
    return str.trim.componentsSeparatedByString(by).filter(){
        return !isEmpty($0)
    }
}

extension String {
    public subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    public var trim :String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    public var trimArray : Array<String>{
        return trimToArray(self)
    }
    
    public func trimArrayBy (str:String) -> Array<String> {
        return trimToArrayBy(self,str)
    }
    
    public var toKeyPath :String {
        var keyArray = self.trim.componentsSeparatedByString("-")
        var str = ""
        var index = 0
        for akey in keyArray {
            if index == 0 {
                str += akey
            }else{
                str += akey.capitalizedString
            }
            index++
        }
        if let reg = Regex("_").replace(str, withTemplate: ".") {
            str = reg
        }
        return str
    }
    
    public var floatValue: CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
    
    public var integerValue: Int {
        return (self as NSString).integerValue
    }
    
    public var boolValue: Bool {
        return (self as NSString).boolValue
    }
    
    public var anyValue :AnyObject{
        var str = self.trim
        
        if str.hasSuffix(".cg"){
            if let color = UIColor(CSS: Regex(".cg").replace(str, withTemplate: "")){
                return color.CGColor
            }
        }
        
        if contains(["YES","NO","TRUE","FALSE"], str.uppercaseString) {
            return str.boolValue
        }else if let color = UIColor(CSS: str){
            return color
        }else if let image = UIImage(named: str){
            return image
        }else if let font = UIFont.Font(str){
            return font
        }else if str.floatValue != 0.0 {
            return str.floatValue
        }else{
            return str
        }
    }
    
    public var MD5 :  String {
        var data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return data!.MD5String
    }
    
    public func toData () -> NSData?{
        return self.dataUsingEncoding(NSUTF8StringEncoding)?.dataByReplacingOccurrencesOfData("\\n".dataUsingEncoding(NSUTF8StringEncoding), withData: "\n".dataUsingEncoding(NSUTF8StringEncoding))
    }
    
    public var chineseFirstLetter : String{
        return HTFirstLetter.firstLetter(self)
    }
    
    public var chineseFirstLetters : String {
        return HTFirstLetter.firstLetters(self)
    }
}
