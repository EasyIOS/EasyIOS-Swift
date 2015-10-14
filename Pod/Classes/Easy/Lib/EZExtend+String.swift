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
        return !$0.characters.isEmpty
    }
}

public func trimToArrayBy (str:String,by:String) -> Array<String>{
    return str.trim.componentsSeparatedByString(by).filter(){
        return !$0.characters.isEmpty
    }
}



extension String {
    public subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
    
    public var urlencode :String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.letterCharacterSet())
    }
    
    public var urldecode :String? {
        return self.stringByRemovingPercentEncoding;
    }
    
    public var trim :String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    public var trimArray : Array<String>{
        return trimToArray(self)
    }
    
    public func trimArrayBy (str:String) -> Array<String> {
        return trimToArrayBy(self,by: str)
    }
    
    public var toKeyPath :String {
        let keyArray = self.trim.componentsSeparatedByString("-")
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
    
    
    public func anyValue(key:String) -> AnyObject{
        if key == "font" {
            if let font = UIFont.Font(self.trim) {
                return font
            }
        }
        return self.anyValue
    }
    
    public var anyValue :AnyObject{
        let str = self.trim
        
        if str.hasSuffix(".cg"){
            if let color = UIColor(CSS: Regex(".cg").replace(str, withTemplate: "")){
                return color.CGColor
            }
        }
        
        if ["YES","NO","TRUE","FALSE"].contains(str.uppercaseString) {
            return str.boolValue
        }else if let color = UIColor(CSS: str){
            return color
        }else if let image = UIImage(named: str){
            return image
        }else if str.floatValue != 0.0 {
            return str.floatValue
        }else{
            return str
        }
    }
    
    public var MD5 : String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
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
