//
//  EZExtend+UILabel.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
// MARK: - UILabel

private var UILabelAttributedStringArray: UInt8 = 0
extension UILabel {
    
    public var attributedStrings: [NSAttributedString]? {
        get {
            return objc_getAssociatedObject(self, &UILabelAttributedStringArray) as? [NSAttributedString]
        } set (value) {
            objc_setAssociatedObject(self, &UILabelAttributedStringArray, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public  func addAttributedString (text: String,
        color: UIColor,
        font: UIFont) {
            let att = NSAttributedString (string: text,
                attributes: [NSFontAttributeName: font,
                    NSForegroundColorAttributeName: color])
            self.addAttributedString(att)
    }
    
    public func addAttributedString (attributedString: NSAttributedString) {
        var att: NSMutableAttributedString?
        
        if let a = self.attributedText {
            att = NSMutableAttributedString (attributedString: a)
            att?.appendAttributedString(attributedString)
        } else {
            att = NSMutableAttributedString (attributedString: attributedString)
            attributedStrings = []
        }
        
        attributedStrings?.append(attributedString)
        self.attributedText = NSAttributedString (attributedString: att!)
    }
    
    
    public func updateAttributedStringAtIndex (index: Int,
        attributedString: NSAttributedString) {
            
            if (attributedStrings?[index] != nil) {
                attributedStrings?.removeAtIndex(index)
                attributedStrings?.insert(attributedString, atIndex: index)
                
                let updated = NSMutableAttributedString ()
                for att in attributedStrings! {
                    updated.appendAttributedString(att)
                }
                
                self.attributedText = NSAttributedString (attributedString: updated)
            }
    }
    
    public func updateAttributedStringAtIndex (index: Int,
        newText: String) {
            if let att = attributedStrings?[index] {
                let newAtt = NSMutableAttributedString (string: newText)
                
                att.enumerateAttributesInRange(NSMakeRange(0, att.string.characters.count-1),
                    options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired,
                    usingBlock: { (attribute, range, stop) -> Void in
                        for (key, value) in attribute {
                            newAtt.addAttribute(key , value: value, range: range)
                        }
                })
                
                updateAttributedStringAtIndex(index, attributedString: newAtt)
            }
    }
    
    
    public func getEstimatedHeight () -> CGFloat {
        let att = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:font])
        let rect = att.boundingRectWithSize(CGSize (width: w, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.height
    }
    
    public func fitHeight () {
        self.h = getEstimatedHeight()
    }
}
