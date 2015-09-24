//
//  EZExtend+UIFont.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
// MARK: - UIFont

extension UIFont {
    
    public enum FontType: String {
        case Regular = "Regular"
        case Bold = "Bold"
        case Light = "Light"
        case UltraLight = "UltraLight"
        case Italic = "Italic"
        case Thin = "Thin"
        case Book = "Book"
        case Roman = "Roman"
        case Medium = "Medium"
        case MediumItalic = "MediumItalic"
        case CondensedMedium = "CondensedMedium"
        case CondensedExtraBold = "CondensedExtraBold"
        case SemiBold = "SemiBold"
        case BoldItalic = "BoldItalic"
        case Heavy = "Heavy"
    }
    
    public enum FontName: String {
        case HelveticaNeue = "HelveticaNeue"
        case Helvetica = "Helvetica"
        case Futura = "Futura"
        case Menlo = "Menlo"
        case Avenir = "Avenir"
        case AvenirNext = "AvenirNext"
        case Didot = "Didot"
        case AmericanTypewriter = "AmericanTypewriter"
        case Baskerville = "Baskerville"
        case Geneva = "Geneva"
        case GillSans = "GillSans"
        case SanFranciscoDisplay = "SanFranciscoDisplay"
        case Seravek = "Seravek"
    }
    
    public class func PrintFontFamily (font: FontName) {
        let arr = UIFont.fontNamesForFamilyName(font.rawValue)
        for name in arr {
            print(name)
        }
    }
    
    public class func Font (str:String) -> UIFont?  {
        var array = str.trimArray
        if array.count >= 2{
            let font = array[1] as String
            if font == "system" {
                return UIFont.systemFontOfSize(array[0].floatValue)
            }else{
                return UIFont(name: array[1], size: array[0].floatValue)
            }
        }else if array.count == 1{
            return UIFont.systemFontOfSize(array[0].floatValue)
        }
        return nil
    }
    
    public class func Font (name: FontName, type: FontType, size: CGFloat) -> UIFont {
        return UIFont (name: name.rawValue + "-" + type.rawValue, size: size)!
    }
    
    public class func HelveticaNeue (type: FontType, size: CGFloat) -> UIFont {
        return Font(.HelveticaNeue, type: type, size: size)
    }
}
