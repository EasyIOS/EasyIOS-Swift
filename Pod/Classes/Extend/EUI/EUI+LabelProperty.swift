//
//  EUI+LabelProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import JavaScriptCore
import TTTAttributedLabel

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
            self.textAlignment = textAlignment.textAlignment
        }
        
        if let linkStyle = EUIParse.string(pelement,key:"link-style") {
            self.linkStyle = linkStyle.linkStyleDict
        }
        
        if let linkStyle = EUIParse.string(pelement,key:"active-link-style") {
            self.activeLinkStyle = linkStyle.linkStyleDict
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

}