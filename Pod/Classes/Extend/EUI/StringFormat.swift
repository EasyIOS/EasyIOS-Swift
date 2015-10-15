//
//  StringFormat.swift
//  Pods
//
//  Created by zhuchao on 15/10/15.
//
//

import Foundation

extension String{
    var viewContentMode:UIViewContentMode{
        var dict = Dictionary<String,UIViewContentMode>()
        dict["ScaleToFill"] = UIViewContentMode.ScaleToFill
        dict["ScaleAspectFit"] = UIViewContentMode.ScaleAspectFit
        dict["ScaleAspectFill"] = UIViewContentMode.ScaleAspectFill
        dict["Redraw"] = UIViewContentMode.Redraw
        dict["Center"] = UIViewContentMode.Center
        dict["Top"] = UIViewContentMode.Top
        dict["Bottom"] = UIViewContentMode.Bottom
        dict["Left"] = UIViewContentMode.Left
        dict["Right"] = UIViewContentMode.Right
        dict["TopLeft"] = UIViewContentMode.TopLeft
        dict["TopRight"] = UIViewContentMode.TopRight
        dict["BottomLeft"] = UIViewContentMode.BottomLeft
        dict["BottomRight"] = UIViewContentMode.BottomRight
        if let mode = dict[self.trim]{
            return mode
        }else{
            return UIViewContentMode.ScaleToFill
        }
    }
    
    var flexContentDirection:FLEXBOXContentDirection{
        switch self.trim {
        case "ltr":
            return .LeftToRight
        case "rtl":
            return .RightToLeft
        case "inherit":
            return .Inherit
        default:
            return .LeftToRight
        }
    }
    
    var justifyContent:FLEXBOXJustification{
        switch self.trim {
        case "center":
            return .Center
        case "flex-start":
            return .FlexStart
        case "flex-end":
            return .FlexEnd
        case "space-between":
            return .SpaceBetween
        case "space-around":
            return .SpaceAround
        default:
            return .FlexStart
        }
    }
    
    var alignItems:FLEXBOXAlignment{
        switch self.trim {
        case "center":
            return .Center
        case "flex-start":
            return .FlexStart
        case "flex-end":
            return .FlexEnd
        case "stretch":
            return .Stretch
        case "auto":
            return .Auto
        default:
            return .Auto
        }
    }
    
    var flexDirection:FLEXBOXFlexDirection{
        switch self.trim {
        case "column":
            return .Column
        case "row":
            return .Row
        case "row-reverse":
            return .RowReverse
        case "column-reverse":
            return .ColumnReverse
        default:
            return .Row
        }
    }
    
    var separatorStyle:UITableViewCellSeparatorStyle{
        switch self.trim{
        case "None" :
            return .None
        case "SingleLine":
            return .SingleLine
        case "SingleLineEtched":
            return .SingleLineEtched
        default:
            return .SingleLine
        }
    }
    
    var tableViewStyle:UITableViewStyle{
        switch self.trim{
        case "plain":
            return .Plain
        case "grouped":
            return .Grouped
        default:
            return .Plain
        }
    }
    
    var scrollViewIndicatorStyle:UIScrollViewIndicatorStyle{
        switch self.trim{
        case "white":
            return .White
        case "black":
            return .Black
        default:
            return .Default
        }
    }
    
    var textAlignment:NSTextAlignment {
        switch(self.trim){
        case "center":
            return NSTextAlignment.Center
        case "left":
            return NSTextAlignment.Left
        case "right":
            return NSTextAlignment.Right
        case "justified":
            return NSTextAlignment.Justified
        case "natural":
            return NSTextAlignment.Natural
        default:
            return NSTextAlignment.Left
        }
    }
    
    var linkStyleDict:[NSObject:AnyObject]{
        let linkArray = self.trimArrayBy(";")
        var dict = Dictionary<NSObject,AnyObject>()
        for str in linkArray {
            var strArray = str.trimArrayBy(":")
            if strArray.count == 2 {
                switch strArray[0] {
                case "color":
                    dict[kCTForegroundColorAttributeName] = UIColor(CSS: strArray[1].trim)
                case "text-decoration":
                    dict[NSUnderlineStyleAttributeName] = strArray[1].trim.underlineStyle.rawValue
                default :
                    dict[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
                }
            }
        }
        return dict
    }
    
    
    var keyboardType:UIKeyboardType {
        
        switch self.lowercaseString {
        case "Default".lowercaseString:
            return UIKeyboardType.Default
        case "ASCIICapable".lowercaseString:
            return UIKeyboardType.ASCIICapable
        case "NumbersAndPunctuation".lowercaseString:
            return UIKeyboardType.NumbersAndPunctuation
        case "URL".lowercaseString:
            return UIKeyboardType.URL
        case "NumberPad".lowercaseString:
            return UIKeyboardType.NumberPad
        case "PhonePad".lowercaseString:
            return UIKeyboardType.PhonePad
        case "NamePhonePad".lowercaseString:
            return UIKeyboardType.NamePhonePad
        case "EmailAddress".lowercaseString:
            return UIKeyboardType.EmailAddress
        case "DecimalPad".lowercaseString:
            return UIKeyboardType.DecimalPad
        case "Twitter".lowercaseString:
            return UIKeyboardType.Twitter
        case "Twitter".lowercaseString:
            return UIKeyboardType.WebSearch
        default:
            return UIKeyboardType.Default
        }
    }
    
    
    var underlineStyle:NSUnderlineStyle{
        switch self.lowercaseString {
        case "None".lowercaseString :
            return NSUnderlineStyle.StyleNone
        case "StyleSingle".lowercaseString :
            return NSUnderlineStyle.StyleSingle
        case "StyleThick".lowercaseString :
            return NSUnderlineStyle.StyleThick
        case "StyleDouble".lowercaseString :
            return NSUnderlineStyle.StyleDouble
        case "PatternDot".lowercaseString :
            return NSUnderlineStyle.PatternDot
        case "PatternDash".lowercaseString :
            return NSUnderlineStyle.PatternDash
        case "PatternDashDot".lowercaseString :
            return NSUnderlineStyle.PatternDashDot
        case "PatternDashDotDot".lowercaseString :
            return NSUnderlineStyle.PatternDashDotDot
        case "ByWord".lowercaseString :
            return NSUnderlineStyle.ByWord
        default :
            return NSUnderlineStyle.StyleSingle
        }
    }
    
    var controlEvent: UIControlEvents{
        switch self.lowercaseString {
        case "TouchDown".lowercaseString :
            return UIControlEvents.TouchDown
        case "TouchDownRepeat".lowercaseString :
            return UIControlEvents.TouchDownRepeat
        case "TouchDragInside".lowercaseString :
            return UIControlEvents.TouchDragInside
        case "TouchDragOutside".lowercaseString :
            return UIControlEvents.TouchDragOutside
        case "TouchDragEnter".lowercaseString :
            return UIControlEvents.TouchDragEnter
        case "TouchDragExit".lowercaseString :
            return UIControlEvents.TouchDragExit
        case "TouchUpInside".lowercaseString :
            return UIControlEvents.TouchUpInside
        case "TouchUpOutside".lowercaseString :
            return UIControlEvents.TouchUpOutside
        case "ValueChanged".lowercaseString :
            return UIControlEvents.ValueChanged
        case "TouchCancel".lowercaseString :
            return UIControlEvents.TouchCancel
        case "EditingDidBegin".lowercaseString :
            return UIControlEvents.EditingDidBegin
        case "EditingChanged".lowercaseString :
            return UIControlEvents.EditingChanged
        case "EditingDidEnd".lowercaseString :
            return UIControlEvents.EditingDidEnd
        case "EditingDidEndOnExit".lowercaseString :
            return UIControlEvents.EditingDidEndOnExit
        case "AllTouchEvents".lowercaseString :
            return UIControlEvents.AllTouchEvents
        case "AllEditingEvents".lowercaseString :
            return UIControlEvents.AllEditingEvents
        case "ApplicationReserved".lowercaseString :
            return UIControlEvents.ApplicationReserved
        case "SystemReserved".lowercaseString :
            return UIControlEvents.SystemReserved
        case "AllEvents".lowercaseString :
            return UIControlEvents.AllEvents
        default :
            return UIControlEvents.TouchUpInside
        }
    }
    
}