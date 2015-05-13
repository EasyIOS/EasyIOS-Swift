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
    var onPan:PanGestureAction?
    var frame:CGRect?
    var bind = Dictionary<String,String>()
    var contentText:String?
    var pushUrl:String?
    var presentUrl:String?
    
    func getView() -> UIView{
        if self.tag == nil {
            return UIView()
        }
        return self.view()
    }
    
    func view() -> UIView{
        var view = UIView()
        view.tagProperty = self
        self.renderViewStyle(view)
        for subTag in self.subTags {
            view.addSubview(subTag.getView())
        }
        return view
    }
    
    func renderTag(pelement:OGElement){
        self.tagOut += ["id","style","align","margin","type","image-mode","name","width","height","class","ontap","onswipe","onpan","frame","reuseid","push","present"]
        
        self.tag = pelement.tag
        
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
                    val.removeAtIndex(advance(val.startIndex, count(val) - 1))
                    self.width = Constrain(name:.Width,value: CGFloat(val.floatValue/100))
                }else{
                    self.width = Constrain(name:.Width,value: CGFloat(values[0].trim.floatValue),target:"")
                }
            }else if values.count >= 2 && values[0].trim.hasSuffix("%"){
                var val = values[0].trim
                val.removeAtIndex(advance(val.startIndex, count(val) - 1))
                self.width = Constrain(name:.Width,value: CGFloat(val.floatValue/100),target:values[1].trim)
            }
        }
        
        if let theHeight = EUIParse.string(pelement,key:"height") {
            var values = theHeight.trimArray
            if values.count == 1 {
                if values[0].hasSuffix("%") {
                    var val = values[0]
                    val.removeAtIndex(advance(val.startIndex, count(val) - 1))
                    self.height = Constrain(name:.Height,value: CGFloat(val.floatValue/100))
                }else{
                    self.height = Constrain(name:.Height,value: CGFloat(values[0].trim.floatValue),target:"")
                }
            }else if values.count >= 2 && values[0].trim.hasSuffix("%"){
                var val = values[0].trim
                val.removeAtIndex(advance(val.startIndex, count(val) - 1))
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
            }else if values.count == 2 {
                self.onTap = TapGestureAction(selector: values[0], tapNumber: values[1])
            }else if values.count >= 3 {
                self.onTap = TapGestureAction(selector: values[0], tapNumber: values[1], target: values[2])
            }
        }
        
        if let theGestureAction = EUIParse.string(pelement, key: "onswipe") {
            var values = theGestureAction.trimArray
            if values.count == 2 {
                self.onSwipe = SwipeGestureAction(selector: values[0], direction: values[1])
            }else if values.count == 3 {
                self.onSwipe = SwipeGestureAction(selector: values[0], direction: values[1], numberOfTouches: values[2])
            }else if values.count >= 4 {
                self.onSwipe = SwipeGestureAction(selector: values[0], direction: values[1], numberOfTouches: values[2], target: values[3])
            }
        }
        
        if let theGestureAction = EUIParse.string(pelement, key: "onpan") {
            var values = theGestureAction.trimArray
            if values.count == 1 {
                self.onPan = PanGestureAction(selector: values[0])
            }else if values.count == 2 {
                self.onPan = PanGestureAction(selector: values[0], target: values[1])
            }
        }
        
        if let push = EUIParse.string(pelement,key: "push") {
            self.pushUrl = push
        }
        
        if let present = EUIParse.string(pelement,key: "present") {
            self.presentUrl = present
        }
        
        for (key,value) in pelement.attributes {
            if contains(self.tagOut, key as! String) == false {
                self.otherProperty[key as! String] = value
            }
        }
        self.childLoop(pelement)
    }
    
    func renderViewStyle(view:UIView){
        view.contentMode = self.imageMode;
        
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
            view.setValue((value as! String).anyValue, forKeyPath: key.toKeyPath)
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
            return UIViewContentMode.ScaleToFill
        case "ScaleAspectFit":
            return UIViewContentMode.ScaleAspectFit
        case "ScaleAspectFill":
            return UIViewContentMode.ScaleAspectFill
        case "Redraw":
            return UIViewContentMode.Redraw
        case "Center":
            return UIViewContentMode.Center
        case "Top":
            return UIViewContentMode.Top
        case "Bottom":
            return UIViewContentMode.Bottom
        case "Left":
            return UIViewContentMode.Left
        case "Right":
            return UIViewContentMode.Right
        case "TopLeft":
            return UIViewContentMode.TopLeft
        case "TopRight":
            return UIViewContentMode.TopRight
        case "BottomLeft":
            return UIViewContentMode.BottomLeft
        case "BottomRight":
            return UIViewContentMode.BottomRight
        default:
            return UIViewContentMode.ScaleToFill
        }
    }
    
    func bindTheKeyPath(str:String,key:String) -> String?{
        let value =  Regex("\\{\\{(\\w+)\\}\\}").replace(str, withBlock: { (regx) -> String in
            var keyPath = regx.subgroupMatchAtIndex(0)?.trim
            self.bind[key] = keyPath
            return ""
        })
        return value
    }
}

