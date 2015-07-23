//
//  EUIProperty.swift
//  medical
//
//  Created by zhuchao on 15/4/30.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

enum CSS:String{
    case MarginTop = "margin-top"
    case MarginLeft = "margin-left"
    case MarginRight = "margin-right"
    case MarginBottom = "margin-bottom"
    
    case AlignTop = "align-top"
    case AlignBottom = "align-bottom"
    case AlignLeft = "align-left"
    case AlignRight = "align-right"
    case AlignCenter = "align-center"
    case AlignCenterX = "align-center-x"
    case AlignCenterY = "align-center-y"
    case AlignEdge = "align-edge"
    
    case Width = "width"
    case Height = "height"
    
}

struct Constrain{
    static var targetSelf = "self"
    static var targetSuper = "super"
    static var targetRoot = "root"
    
    var value:CGFloat = 0.0
    var target = targetSuper
    var constrainName = CSS.AlignEdge
    
    init(name:CSS,value:CGFloat,target:String = targetSuper){
        self.constrainName = name
        self.value = value
        self.target = target
    }
}

struct SelectorAction{
    var selector:String = ""
    var event:UIControlEvents = UIControlEvents.TouchUpInside
    
    init(selector:String,event:String = "TouchUpInside"){
        self.selector = selector
        self.event = controlEventFromString(event)
    }
}

struct PullRefreshAction {
    var selector:String = ""
    var viewClass:String = ""
    
    init(selector:String,viewClass:String = ""){
        self.selector = selector
        self.viewClass = viewClass
    }
}

struct InfiniteScrollingAction {
    var selector:String = ""
    var viewClass:String = ""
    
    init(selector:String,viewClass:String = ""){
        self.selector = selector
        self.viewClass = viewClass
    }
}

struct TapGestureAction{
    var selector:String = ""
    var tapNumber:NSInteger = 1
    init(selector:String,tapNumber:String = "1"){
        self.selector = selector
        self.tapNumber = tapNumber.integerValue
    }
}

struct SwipeGestureAction {
    
    var direction: UISwipeGestureRecognizerDirection
    var selector:String
    var numberOfTouches:Int = 1
    
    init(selector:String,direction:String,numberOfTouches:String = "1"){
        self.selector = selector
        self.numberOfTouches = numberOfTouches.integerValue
        switch direction.lowercaseString {
        case "up" :
            self.direction = .Up
        case "down" :
            self.direction = .Down
        case "right" :
            self.direction = .Right
        case "left" :
            self.direction = .Left
        default :
            self.direction = .Up
        }
    }
}


func keyboardTypeFromString(type:String) -> UIKeyboardType {
    
    switch type.lowercaseString {
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


func underlineStyleFromString(style:String) -> NSUnderlineStyle{
    switch style.lowercaseString {
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

func controlEventFromString(event:String) -> UIControlEvents{
    switch event.lowercaseString {
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

