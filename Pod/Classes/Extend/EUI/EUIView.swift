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


@objc public protocol EUIImage:JSExport,ENSObject{
    init(named name: String)// load from main bundle
    @availability(iOS, introduced=8.0)
    init(named name: String, inBundle bundle: NSBundle?, compatibleWithTraitCollection traitCollection: UITraitCollection?)
    init?(contentsOfFile path: String)
}

@objc public protocol EUIImageView:JSExport,EUIView,ENSObject{
    init(image: UIImage!)
    init(image: UIImage!, highlightedImage: UIImage?)
}

@objc public protocol EUITextField:JSExport,EUIView,ENSObject{

}

@objc public protocol EUIButton:JSExport,EUIView,ENSObject{
    
}



