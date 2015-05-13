//
//  EUI+LabelProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

class LabelProperty:ViewProperty{
    var text:NSData?
     
    override func view() -> UIView{
        var view = UILabel()
        view.tagProperty = self
        
        if let atext = self.text {
            if isEmpty(self.style) {
                view.text = self.contentText
            }else{
                view.attributedText = NSAttributedString(fromHTMLData: atext, attributes: ["dict":self.style])
            }
        }
        
        self.renderViewStyle(view)
        return view
    }
    
    override func renderTag(pelement: OGElement) {
        var html = ""
        for child in pelement.children
        {
            html += child.html().trim
        }
        
        if let newHtml = self.bindTheKeyPath(html, key: "text") {
            html = newHtml
        }
        
        if !isEmpty(html) {
            self.contentText = html
            self.text = html.dataUsingEncoding(NSUTF8StringEncoding)?.dataByReplacingOccurrencesOfData("\\n".dataUsingEncoding(NSUTF8StringEncoding), withData: "\n".dataUsingEncoding(NSUTF8StringEncoding))
        }
        super.renderTag(pelement)
    }
    
    override func childLoop(pelement: OGElement) {
        
    }

}