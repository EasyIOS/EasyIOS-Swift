//
//  CEMKit.swift
//  CEMKit-Swift
//
//  Created by Cem Olcay on 05/11/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit



// MARK: - UIBarButtonItem

public func barButtonItem (imageName: String,
    action: (AnyObject)->()) -> UIBarButtonItem {
        let button = BlockButton (frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.actionBlock = action
        
        return UIBarButtonItem (customView: button)
}

public func barButtonItem (title: String,
    color: UIColor,
    action: (AnyObject)->()) -> UIBarButtonItem {
        let button = BlockButton (frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(color, forState: .Normal)
        button.actionBlock = action
        button.sizeToFit()
        
        return UIBarButtonItem (customView: button)
}



// MARK: - CGSize

public func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize (width: left.width + right.width, height: left.height + right.height)
}

public func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize (width: left.width - right.width, height: left.width - right.width)
}



// MARK: - CGPoint

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint (x: left.x + right.x, y: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint (x: left.x - right.x, y: left.y - right.y)
}


public enum AnchorPosition: CGPoint {
    case TopLeft        = "{0, 0}"
    case TopCenter      = "{0.5, 0}"
    case TopRight       = "{1, 0}"
    
    case MidLeft        = "{0, 0.5}"
    case MidCenter      = "{0.5, 0.5}"
    case MidRight       = "{1, 0.5}"
    
    case BottomLeft     = "{0, 1}"
    case BottomCenter   = "{0.5, 1}"
    case BottomRight    = "{1, 1}"
}

extension CGPoint: StringLiteralConvertible {
    
    public init(stringLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }
}



// MARK: - CGFloat

public func degreesToRadians (angle: CGFloat) -> CGFloat {
    return (CGFloat (M_PI) * angle) / 180.0
}


public func normalizeValue (value: CGFloat,
    min: CGFloat,
    max: CGFloat) -> CGFloat {
    return (max - min) / value
}


public func convertNormalizedValue (value: CGFloat,
    min: CGFloat,
    max: CGFloat) -> CGFloat {
    return ((max - min) * value) + min
}



// MARK: - Block Classes


// MARK: - BlockButton

public class BlockButton: UIButton {
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var actionBlock: ((sender: BlockButton) -> ())? {
        didSet {
            self.addTarget(self, action: "action:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func action (sender: BlockButton) {
        actionBlock! (sender: sender)
    }
}



// MARK: - BlockWebView

public class BlockWebView: UIWebView, UIWebViewDelegate {
    
    var didStartLoad: ((NSURLRequest?) -> ())?
    var didFinishLoad: ((NSURLRequest?) -> ())?
    var didFailLoad: ((NSURLRequest?, NSError?) -> ())?
    
    var shouldStartLoadingRequest: ((NSURLRequest) -> (Bool))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc public func webViewDidStartLoad(webView: UIWebView) {
        didStartLoad? (webView.request)
    }
    
    @objc public func webViewDidFinishLoad(webView: UIWebView) {
        didFinishLoad? (webView.request)
    }
    @objc  public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        didFailLoad? (webView.request, error)
    }
    
    @objc public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let should = shouldStartLoadingRequest {
            return should (request)
        } else {
            return true
        }
    }
    
}


public func nsValueForAny(anyValue:Any) -> NSObject? {
    switch(anyValue) {
    case let intValue as Int:
        return NSNumber(int: CInt(intValue))
    case let doubleValue as Double:
        return NSNumber(double: CDouble(doubleValue))
    case let stringValue as String:
        return stringValue as NSString
    case let boolValue as Bool:
        return NSNumber(bool: boolValue)
    default:
        return nil
    }
}

extension NSObject{
    public class var nameOfClass: String{
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    public var nameOfClass: String{
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }

    
    public func listProperties() -> Dictionary<String,AnyObject>{

        var modelDictionary = Dictionary<String,AnyObject>()
        Mirror(reflecting: self).children.forEach { (element) -> () in
            if  element.label != "super" {
                if let nsValue = nsValueForAny(element.value) {
                    modelDictionary.updateValue(nsValue, forKey: element.label!)
                }
            }
        }
        return modelDictionary
    }
    
}


public func isEmpty<C : NSObject>(x: C) -> Bool {
    if x.isKindOfClass(NSNull) {
        return true
    }else if x.respondsToSelector(Selector("length")) && NSData().self.length == 0 {
        return true
    }else if x.respondsToSelector(Selector("count")) && NSArray().self.count == 0 {
        return true
    }
    return false
}




