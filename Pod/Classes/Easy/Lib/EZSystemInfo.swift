//
//  EZSystemInfo.swift
//  medical
//
//  Created by zhuchao on 15/4/22.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

#if os(iOS)
let IOS10_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("10.0") != NSComparisonResult.OrderedAscending)
let IOS9_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("9.0") != NSComparisonResult.OrderedAscending)
let IOS8_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("8.0") != NSComparisonResult.OrderedAscending)
let IOS7_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("7.0") != NSComparisonResult.OrderedAscending)
let IOS6_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("6.0") != NSComparisonResult.OrderedAscending)
let IOS5_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("5.0") != NSComparisonResult.OrderedAscending)
let IOS4_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("4.0") != NSComparisonResult.OrderedAscending)
let IOS3_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("3.0") != NSComparisonResult.OrderedAscending)

let IOS9_OR_EARLIER = !IOS10_OR_LATER
let IOS8_OR_EARLIER = !IOS9_OR_LATER
let IOS7_OR_EARLIER = !IOS8_OR_LATER
let IOS6_OR_EARLIER = !IOS7_OR_LATER
let IOS5_OR_EARLIER = !IOS6_OR_LATER
let IOS4_OR_EARLIER = !IOS5_OR_LATER
let IOS3_OR_EARLIER = !IOS4_OR_LATER

let IS_SCREEN_4_INCH = CGSizeEqualToSize(CGSizeMake(640, 1136), UIScreen.mainScreen().currentMode!.size)
let IS_SCREEN_35_INCH = CGSizeEqualToSize(CGSizeMake(640, 960), UIScreen.mainScreen().currentMode!.size)
let IS_SCREEN_47_INCH = CGSizeEqualToSize(CGSizeMake(750, 1334), UIScreen.mainScreen().currentMode!.size)
let IS_SCREEN_55_INCH = CGSizeEqualToSize(CGSizeMake(1242, 2208), UIScreen.mainScreen().currentMode!.size)

#else
let IOS9_OR_LATER = false
let IOS8_OR_LATER = false
let IOS7_OR_LATER = false
let IOS6_OR_LATER = false
let IOS5_OR_LATER = false
let IOS4_OR_LATER = false
let IOS3_OR_LATER = false
    
let IOS9_OR_EARLIER = false
let IOS8_OR_EARLIER = false
let IOS7_OR_EARLIER = false
let IOS6_OR_EARLIER = false
let IOS5_OR_EARLIER = false
let IOS4_OR_EARLIER = false
let IOS3_OR_EARLIER = false
    
let IS_SCREEN_4_INCH = false
let IS_SCREEN_35_INCH = false
let IS_SCREEN_47_INCH = false
let IS_SCREEN_55_INCH = false
#endif


public var IsSimulator:Bool {
#if (arch(i386) || arch(x86_64)) && os(iOS)
    return true;
#else
    return false;
#endif
}

public func OSVersion() ->String{
#if os(iOS)
    return UIDevice.currentDevice().systemName + " " + UIDevice.currentDevice().systemVersion
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return ""
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

//func AppVersion() ->String{
//    var value = NSBundle.mainBundle().infoDictionary["CFBundleVersion"]
//    if nil == value || 0 == value.length
//    {
//    value = NSBundle.mainBundle().infoDictionary["CFBundleShortVersion"]
//    }
//    return value
//}

//func AppIdentifier() ->String{
//#if os(iOS)
//    var value = NSBundle.mainBundle().infoDictionary["CFBundleVersion"]
//    if nil == value || 0 == value.length
//    {
//    value = NSBundle.mainBundle().infoDictionary["CFBundleShortVersion"]
//    }
//    return value
//#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
//    return ""
//#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
//}




public var Orientation: UIInterfaceOrientation {
get {
    return UIApplication.sharedApplication().statusBarOrientation
}
}

public var ScreenWidth: CGFloat {
get {
    if UIInterfaceOrientationIsPortrait(Orientation) {
        return UIScreen.mainScreen().bounds.size.width
    } else {
        return UIScreen.mainScreen().bounds.size.height
    }
}
}

public var ScreenHeight: CGFloat {
get {
    if UIInterfaceOrientationIsPortrait(Orientation) {
        return UIScreen.mainScreen().bounds.size.height
    } else {
        return UIScreen.mainScreen().bounds.size.width
    }
}
}

public var StatusBarHeight: CGFloat {
get {
    return UIApplication.sharedApplication().statusBarFrame.height
}
}

