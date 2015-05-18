//
//  EUI+LabelProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import TTTAttributedLabel

class LabelProperty:ViewProperty{
    var linkStyle = Dictionary<NSObject,AnyObject>()
    var activeLinkStyle = Dictionary<NSObject,AnyObject>()
    
    override func view() -> UIView{
        if isEmpty(self.style) {
            var view = UILabel()
            view.tagProperty = self
            view.text = self.contentText
            self.renderViewStyle(view)
            return view
        }else{
            var view = TTTAttributedLabel()
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
        
        self.tagOut += ["link-style","active-link-style"]
        super.renderTag(pelement)
        
        if let linkStyle = EUIParse.string(pelement,key:"link-style") {
            self.linkStyle = self.formatLink(linkStyle)
        }
        
        if let linkStyle = EUIParse.string(pelement,key:"active-link-style") {
            self.activeLinkStyle = self.formatLink(linkStyle)
        }
        
        var html = ""
        for child in pelement.children
        {
            html += child.html().trim
        }
        var bindKey = "text"
        if !isEmpty(self.style) {
            bindKey = "TTText"
        }
        if let newHtml = self.bindTheKeyPath(html, key: bindKey) {
            html = newHtml
        }
        self.contentText = html
    }
    
    override func childLoop(pelement: OGElement) {
        
    }
    
    func formatLink(linkStyle:String) -> [NSObject:AnyObject]{
        var linkArray = linkStyle.trimArrayBy(";")
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