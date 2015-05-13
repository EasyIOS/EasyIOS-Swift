//
//  EUI+ButtonProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

class ButtonProperty:LabelProperty{
    
    var highlightedStyle = ""
    var disabledStyle = ""
    var selectedStyle = ""
    var applicationStyle = ""
    var reservedStyle = ""
    
    var highlightedText:NSData?
    var disabledText:NSData?
    var selectedText:NSData?
    var applicationText:NSData?
    var reservedText:NSData?
    var onEvent:SelectorAction?
    
    override func view() -> UIButton{
        var view = UIButton()
        view.tagProperty = self
        
        if self.style != "" {
            view.setAttributedTitle(NSAttributedString(fromHTMLData: self.text, attributes: ["html":self.style]), forState: UIControlState.Normal)
        }
        
        if self.highlightedText != nil {
            view.setAttributedTitle(NSAttributedString(fromHTMLData: self.highlightedText, attributes: ["html":self.highlightedStyle]), forState: UIControlState.Highlighted)
        }
        
        if self.disabledText != nil {
            view.setAttributedTitle(NSAttributedString(fromHTMLData: self.disabledText, attributes: ["html":self.disabledStyle]), forState: UIControlState.Disabled)
        }
        
        if self.selectedText != nil {
            view.setAttributedTitle(NSAttributedString(fromHTMLData: self.selectedText, attributes: ["html":self.selectedStyle]), forState: UIControlState.Selected)
        }
        
        if self.applicationText != nil {
            view.setAttributedTitle(NSAttributedString(fromHTMLData: self.applicationText, attributes: ["html":self.applicationStyle]), forState: UIControlState.Application)
        }
        
        if self.reservedText != nil {
            view.setAttributedTitle(NSAttributedString(fromHTMLData: self.reservedText, attributes: ["html":self.reservedStyle]), forState: UIControlState.Reserved)
        }

        self.renderViewStyle(view)
        return view
    }
    
    override func renderTag(pelement: OGElement) {
        self.tagOut += ["highlighted","disabled","selected","application","reserved","disabled-text",
        "selected-text","application-text","reserved-text","highlighted-text","onevent"]
        
        if let highlightedStyle = EUIParse.string(pelement,key: "highlighted") {
            self.highlightedStyle = "html{" + highlightedStyle + "}"
        }
        
        if let disabledStyle = EUIParse.string(pelement,key: "disabled") {
            self.disabledStyle = "html{" + disabledStyle + "}"
        }
        
        if let selectedStyle = EUIParse.string(pelement,key: "selected") {
            self.selectedStyle = "html{" + selectedStyle + "}"
        }
        
        if let applicationStyle = EUIParse.string(pelement,key: "application") {
            self.applicationStyle = "html{" + applicationStyle + "}"
        }
        
        if let reservedStyle = EUIParse.string(pelement,key: "reserved") {
            self.reservedStyle = "html{" + reservedStyle + "}"
        }

        
        self.setText(pelement, key: "disabled-text")
        self.setText(pelement, key: "selected-text")
        self.setText(pelement, key: "application-text")
        self.setText(pelement, key: "reserved-text")
        self.setText(pelement, key: "highlighted-text")
        
        
        if let theSelector = EUIParse.string(pelement, key: "onevent") {
            var values = theSelector.trimArrayBy(":")
            if values.count == 2 {
                var event = values[0]
                var secondArray = values[1].trimArray
                if secondArray.count == 1 {
                    self.onEvent = SelectorAction(selector: secondArray[0], event: event)
                }else if values.count >= 2 {
                    self.onEvent = SelectorAction(selector: secondArray[0], event: event, target: secondArray[1])
                }
            }
        }
        
        super.renderTag(pelement)
    }
    
    func setText(pelement: OGElement,key:String){
        var str = self.text
        if let value = EUIParse.string(pelement,key: key)  {
            self.setValue(value.dataUsingEncoding(NSUTF8StringEncoding), forKey: key)
        }
    }

}
