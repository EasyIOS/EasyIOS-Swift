//
//  EUIView.swift
//  Pods
//
//  Created by zhuchao on 15/7/21.
//
//

import CoreImage
import UIKit
import JavaScriptCore

@objc public protocol EUIView:JSExport,ENSObject{
    
}

@objc public protocol EUIImageView:JSExport,EUIView,ENSObject{
    init(image: UIImage!)
    init(image: UIImage!, highlightedImage: UIImage?)
}

@objc public protocol EUITextField:JSExport,EUIView,ENSObject{

}

@objc public protocol EUIButton:JSExport,EUIView,ENSObject{
    
}

@objc public protocol EUIScrollView:JSExport,EUIView,ENSObject{
    
}

@objc public protocol EUITableView:JSExport,EUIScrollView,ENSObject{
    
}

@objc public protocol EUICollectionView:JSExport,EUIScrollView,ENSObject{
    
}


@objc public protocol EUILabel:JSExport,EUIView,ENSObject{
    
}

@objc public protocol EUIColor:JSExport,ENSObject{
    static func blackColor() -> UIColor // 0.0 white
    static func darkGrayColor() -> UIColor // 0.333 white
    static func lightGrayColor() -> UIColor // 0.667 white
    static func whiteColor() -> UIColor // 1.0 white
    static func grayColor() -> UIColor // 0.5 white
    static func redColor() -> UIColor // 1.0, 0.0, 0.0 RGB
    static func greenColor() -> UIColor // 0.0, 1.0, 0.0 RGB
    static func blueColor() -> UIColor // 0.0, 0.0, 1.0 RGB
    static func cyanColor() -> UIColor // 0.0, 1.0, 1.0 RGB
    static func yellowColor() -> UIColor // 1.0, 1.0, 0.0 RGB
    static func magentaColor() -> UIColor // 1.0, 0.0, 1.0 RGB
    static func orangeColor() -> UIColor // 1.0, 0.5, 0.0 RGB
    static func purpleColor() -> UIColor // 0.5, 0.0, 0.5 RGB
    static func brownColor() -> UIColor // 0.6, 0.4, 0.2 RGB
    static func clearColor() -> UIColor // 0.0 white, 0.0 alpha
}

@objc public protocol EUIImage:JSExport,ENSObject{
    init(named name: String)// load from main bundle
    @available(iOS, introduced=8.0)
    init(named name: String, inBundle bundle: NSBundle?, compatibleWithTraitCollection traitCollection: UITraitCollection?)
    init?(contentsOfFile path: String)
}

