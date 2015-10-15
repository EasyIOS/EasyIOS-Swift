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
        self.event = event.controlEvent
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



