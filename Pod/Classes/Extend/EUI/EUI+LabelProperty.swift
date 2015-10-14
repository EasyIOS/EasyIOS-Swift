//
//  EUI+LabelProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import TTTAttributedLabel
import JavaScriptCore



class LabelProperty:ViewProperty{
    var linkStyle = Dictionary<NSObject,AnyObject>()
    var activeLinkStyle = Dictionary<NSObject,AnyObject>()
    var textAlignment:NSTextAlignment = .Left
    
    override func view() -> UIView{
        if self.style.characters.isEmpty {
            let view = UILabel()
            view.tagProperty = self
            view.text = self.contentText
            self.renderViewStyle(view)
            return view
        }else{
            let view = TTTAttributedLabel(frame: CGRectZero)
            view.tagProperty = self
            if self.linkStyle.count > 0 {
                view.linkAttributes = self.linkStyle
            }
            if self.activeLinkStyle.count > 0 {
                view.activeLinkAttributes = self.activeLinkStyle
            }
            view.setText(NSAttributedString(fromHTMLData: self.contentText?.toData(), attributes: ["dict":self.style]))
            self.renderViewStyle(view)
            return view
        }
    }
    
    override func renderTag(pelement: OGElement) {
        
        self.tagOut += ["link-style","active-link-style","text-alignment"]
        super.renderTag(pelement)
        
        if let textAlignment = EUIParse.string(pelement,key:"text-alignment") {
            self.textAlignment = LabelProperty.textAlignmentFormat(textAlignment)
        }
        
        if let linkStyle = EUIParse.string(pelement,key:"link-style") {
            self.linkStyle = LabelProperty.formatLink(linkStyle)
        }
        
        if let linkStyle = EUIParse.string(pelement,key:"active-link-style") {
            self.activeLinkStyle = LabelProperty.formatLink(linkStyle)
        }
        
        var html = ""
        for child in pelement.children
        {
            html += child.html().trim
        }
        var bindKey = "text"
        if !self.style.characters.isEmpty {
            bindKey = "TTText"
        }
        if let newHtml = self.bindTheKeyPath(html, key: bindKey) {
            html = newHtml
        }
        self.contentText = html
    }
    
    override func childLoop(pelement: OGElement) {
        
    }
    
    override func renderViewStyle(view:UIView){
        super.renderViewStyle(view)
        let sview = view as! UILabel
        sview.textAlignment = self.textAlignment

    }
    
    class func textAlignmentFormat(align:String) ->NSTextAlignment {
        switch(align.trim){
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
                return NSTextAlignment.Natural
        }
    }
    
    class func formatLink(linkStyle:String) -> [NSObject:AnyObject]{
        let linkArray = linkStyle.trimArrayBy(";")
        var dict = Dictionary<NSObject,AnyObject>()
        for str in linkArray {
            var strArray = str.trimArrayBy(":")
            if strArray.count == 2 {
                switch strArray[0] {
                case "color":
                    dict[kCTForegroundColorAttributeName] = UIColor(CSS: strArray[1].trim)
                case "text-decoration":
                    dict[NSUnderlineStyleAttributeName] = underlineStyleFromString(strArray[1].trim).rawValue
                default :
                    dict[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
                }
            }
        }
        return dict
    }

}