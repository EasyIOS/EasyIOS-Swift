//
//  EUIColor.swift
//  Pods
//
//  Created by zhuchao on 15/7/21.
//
//

import UIKit
import JavaScriptCore

@objc public protocol EUIColor:JSExport{
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

