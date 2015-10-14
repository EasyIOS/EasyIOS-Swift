//
//  EUI+ViewProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/2.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation


class ViewProperty :NSObject{
    
    var tag:GumboTag?
    var tagId = ""
    var style = ""
    var type = ""
    var subTags = Array<ViewProperty>()
    var otherProperty = Dictionary<String,AnyObject>()
    var tagOut = Array<String>()
    var imageMode = UIViewContentMode.ScaleAspectFill
    var align = Array<Constrain>()
    var margin = Array<Constrain>()
    var width:Constrain?
    var height:Constrain?
    var onTap:TapGestureAction?
    var onSwipe:SwipeGestureAction?
    var onTapBind:TapGestureAction?
    var onSwipeBind:SwipeGestureAction?
    var frame:CGRect?
    var bind = Dictionary<String,String>()
    var contentText:String?
    var flexEnable = false
    
    var flexDirection:FLEXBOXFlexDirection = .Column
    var flexContentDirection:FLEXBOXContentDirection = .LeftToRight
    var flexJustifyContent:FLEXBOXJustification = .FlexStart
    var flexAlignSelf:FLEXBOXAlignment = .Auto
    var flexAlignItems:FLEXBOXAlignment = .Stretch
    
    var flexMargin = UIEdgeInsetsZero
    var flexPadding = UIEdgeInsetsZero
    var flexWrap = false
    var flex:CGFloat = 0.0
    
    func getView() -> UIView{
        if self.tag == nil {
            return UIView()
        }
        return self.view()
    }
    
    func view() -> UIView{
        if(flexEnable){
            let view = FLEXBOXContainerView()
            view.tagProperty = self
            self.renderViewStyle(view)
            for subTag in self.subTags {
                view.addSubview(subTag.getView())
            }
            return view
        }else{
            let view = UIView()
            view.tagProperty = self
            self.renderViewStyle(view)
            for subTag in self.subTags {
                view.addSubview(subTag.getView())
            }
            return view
        }
    }
    
    func renderTag(pelement:OGElement){
        self.tagOut += ["id","style","align","margin","type","image-mode","name","width","height","class","ontap","onswipe","ontap-bind","onswipe-bind","frame","reuseid","push","present","align-self","align-items","justify-content","flex-direction","content-direction","flex-margin","flex-padding","flex-wrap","flex"]
        
        self.tag = pelement.tag
        
        if let flexMargin = EUIParse.string(pelement, key: "flex-margin"){
            self.flexEnable = true
            self.flexMargin = UIEdgeInsetsFromString(flexMargin)
        }
        if let flexPadding = EUIParse.string(pelement, key: "flex-padding"){
            self.flexEnable = true
            self.flexPadding = UIEdgeInsetsFromString(flexPadding)
        }
        if let flexWrap = EUIParse.string(pelement, key: "flex-wrap"){
            self.flexEnable = true
            self.flexWrap = flexWrap.boolValue
        }
        if let flex = EUIParse.string(pelement, key: "flex"){
            self.flexEnable = true
            self.flex = flex.floatValue
        }
        
        if let alignSelf = EUIParse.string(pelement, key: "align-self"){
            self.flexEnable = true
            self.flexAlignSelf = ViewProperty.alignItemsFormat(alignSelf)
        }
        if let alignItems = EUIParse.string(pelement, key: "align-items"){
            self.flexEnable = true
            self.flexAlignItems = ViewProperty.alignItemsFormat(alignItems)
        }
        if let justifyContent = EUIParse.string(pelement, key: "justify-content"){
            self.flexEnable = true
            self.flexJustifyContent = ViewProperty.justifyContentFormat(justifyContent)
        }
        if let flexDirection = EUIParse.string(pelement, key: "flex-direction"){
            self.flexEnable = true
            self.flexDirection = ViewProperty.flexDirectionFormat(flexDirection)
        }
        if let contentDirection = EUIParse.string(pelement, key: "content-direction"){
            self.flexEnable = true
            self.flexContentDirection = ViewProperty.flexContentDirectionFormat(contentDirection)
        }
        
        if let tagId = EUIParse.string(pelement,key:"id") {
            self.tagId = tagId
        }
      
        if let style = EUIParse.string(pelement,key:"style") {
            self.style = "html{" + style + "}"
        }
        
        if let theAlign = EUIParse.getStyleProperty(pelement,key: "align") {
            self.align = theAlign
        }
        
        if let theMargin = EUIParse.getStyleProperty(pelement,key: "margin") {
            self.margin = theMargin
        }
        
        if let theWidth = EUIParse.string(pelement,key:"width") {
            var values = theWidth.trimArray
            if values.count == 1 {
                if values[0].hasSuffix("%") {
                    var val = values[0]
                    val.removeAtIndex(val.startIndex.advancedBy(val.characters.count - 1))
                    self.width = Constrain(name:.Width,value: CGFloat(val.floatValue/100))
                }else{
                    self.width = Constrain(name:.Width,value: CGFloat(values[0].trim.floatValue),target:"")
                }
            }else if values.count >= 2 && values[0].trim.hasSuffix("%"){
                var val = values[0].trim
                val.removeAtIndex(val.startIndex.advancedBy(val.characters.count - 1))
                self.width = Constrain(name:.Width,value: CGFloat(val.floatValue/100),target:values[1].trim)
            }
        }
        
        if let theHeight = EUIParse.string(pelement,key:"height") {
            var values = theHeight.trimArray
            if values.count == 1 {
                if values[0].hasSuffix("%") {
                    var val = values[0]
                    val.removeAtIndex(val.startIndex.advancedBy(val.characters.count - 1))
                    self.height = Constrain(name:.Height,value: CGFloat(val.floatValue/100))
                }else{
                    self.height = Constrain(name:.Height,value: CGFloat(values[0].trim.floatValue),target:"")
                }
            }else if values.count >= 2 && values[0].trim.hasSuffix("%"){
                var val = values[0].trim
                val.removeAtIndex(val.startIndex.advancedBy(val.characters.count - 1))
                self.height = Constrain(name:.Height,value: CGFloat(val.floatValue/100),target:values[1].trim)
            }
        }
        
        if let frame = EUIParse.string(pelement, key: "frame") {
            self.frame = CGRectFromString(frame)
        }
        
        if let theType = EUIParse.string(pelement,key:"type") {
            self.type = theType
        }
        
        if let theImageMode = EUIParse.string(pelement,key:"image-mode") {
            self.imageMode = ViewProperty.imageModeFormat(theImageMode)
        }
        
        if let theGestureAction = EUIParse.string(pelement, key: "ontap") {
            var values = theGestureAction.trimArray
            if values.count == 1 {
                self.onTap = TapGestureAction(selector: values[0])
            }else if values.count >= 2 {
                self.onTap = TapGestureAction(selector: values[0], tapNumber: values[1])
            }
        }
        
        if let theGestureAction = EUIParse.string(pelement, key: "onswipe") {
            var values = theGestureAction.trimArray
            if values.count == 2 {
                self.onSwipe = SwipeGestureAction(selector: values[0], direction: values[1])
            }else if values.count >= 3 {
                self.onSwipe = SwipeGestureAction(selector: values[0], direction: values[1], numberOfTouches: values[2])
            }
        }
        
        
        if let theGestureAction = EUIParse.string(pelement, key: "ontap-bind") {
            var values = theGestureAction.trimArray
            if values.count == 1 {
                self.onTapBind = TapGestureAction(selector: values[0])
            }else if values.count >= 2 {
                self.onTapBind = TapGestureAction(selector: values[0], tapNumber: values[1])
            }
        }
        
        if let theGestureAction = EUIParse.string(pelement, key: "onswipe-bind") {
            var values = theGestureAction.trimArray
            if values.count == 2 {
                self.onSwipeBind = SwipeGestureAction(selector: values[0], direction: values[1])
            }else if values.count >= 3 {
                self.onSwipeBind = SwipeGestureAction(selector: values[0], direction: values[1], numberOfTouches: values[2])
            }
        }
        
        for (key,value) in pelement.attributes {
            if self.tagOut.contains((key as! String)) == false {
                self.otherProperty[key as! String] = value
            }
        }
        self.childLoop(pelement)
    }
    
    func renderViewStyle(view:UIView){
        view.contentMode = self.imageMode;
        if(self.flexEnable){
            view.flexDirection = self.flexDirection
            view.flexContentDirection = self.flexContentDirection
            view.flexAlignItems = self.flexAlignItems
            view.flexAlignSelf = self.flexAlignSelf
            view.flexJustifyContent = self.flexJustifyContent
            view.flexMargin = self.flexMargin
            view.flexPadding = self.flexPadding
            view.flexWrap = self.flexWrap
            view.flex = self.flex
        }
        
        if let frame = self.frame {
            view.frame = frame
        }
        
        for (key,value) in self.otherProperty {
            var theValue: AnyObject = value
            if let str = value as? String {
                if let newValue = self.bindTheKeyPath(str, key: key) {
                    theValue = newValue
                }
                if theValue as! String == "" {
                    continue
                }
            }
            view.attr(key, value)
        }
    }
    
    func childLoop(pelement:OGElement){
        for element in pelement.children {
            if element.isKindOfClass(OGElement) {
                if let pro = EUIParse.loopElement(element as! OGElement) {
                    self.subTags.append(pro)
                }
            }
        }
    }
    
    
    class func imageModeFormat(str:String) -> UIViewContentMode{
        switch str.trim {
        case "ScaleToFill":
            return .ScaleToFill
        case "ScaleAspectFit":
            return .ScaleAspectFit
        case "ScaleAspectFill":
            return .ScaleAspectFill
        case "Redraw":
            return .Redraw
        case "Center":
            return .Center
        case "Top":
            return .Top
        case "Bottom":
            return .Bottom
        case "Left":
            return .Left
        case "Right":
            return .Right
        case "TopLeft":
            return .TopLeft
        case "TopRight":
            return .TopRight
        case "BottomLeft":
            return .BottomLeft
        case "BottomRight":
            return .BottomRight
        default:
            return .ScaleToFill
        }
    }
    
    
    class func justifyContentFormat(str:String) -> FLEXBOXJustification{
        switch str.trim {
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
    
    class func alignItemsFormat(str:String) -> FLEXBOXAlignment{
        switch str.trim {
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
    
    class func flexDirectionFormat(str:String) -> FLEXBOXFlexDirection{
        switch str.trim {
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
    
    class func flexContentDirectionFormat(str:String) -> FLEXBOXContentDirection{
        switch str.trim {
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

    func bindTheKeyPath(str:String,key:String) -> String?{
        let value =  Regex("\\{\\{(\\w+)\\}\\}").replace(str, withBlock: { (regx) -> String in
            let keyPath = regx.subgroupMatchAtIndex(0)?.trim
            self.bind[key] = keyPath
            return ""
        })
        return value
    }
}

