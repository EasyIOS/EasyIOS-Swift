//
//  EZSystemInfo.swift
//  medical
//
//  Created by zhuchao on 15/4/22.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
var IOS8_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("8.0") != NSComparisonResult.OrderedAscending)
var IOS7_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("7.0") != NSComparisonResult.OrderedAscending)
var IOS6_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("6.0") != NSComparisonResult.OrderedAscending)
var IOS5_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("5.0") != NSComparisonResult.OrderedAscending)
var IOS4_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("4.0") != NSComparisonResult.OrderedAscending)
var IOS3_OR_LATER = (UIDevice.currentDevice().systemVersion.caseInsensitiveCompare("3.0") != NSComparisonResult.OrderedAscending)

var IOS7_OR_EARLIER = !IOS8_OR_LATER
var IOS6_OR_EARLIER = !IOS7_OR_LATER
var IOS5_OR_EARLIER = !IOS6_OR_LATER
var IOS4_OR_EARLIER = !IOS5_OR_LATER
var IOS3_OR_EARLIER = !IOS4_OR_LATER

var IS_SCREEN_4_INCH = CGSizeEqualToSize(CGSizeMake(640, 1136), UIScreen.mainScreen().currentMode?.size)
var IS_SCREEN_35_INCH = CGSizeEqualToSize(CGSizeMake(640, 960), UIScreen.mainScreen().currentMode?.size)
var IS_SCREEN_47_INCH = CGSizeEqualToSize(CGSizeMake(750, 1334), UIScreen.mainScreen().currentMode?.size)
var IS_SCREEN_55_INCH = CGSizeEqualToSize(CGSizeMake(1242, 2208), UIScreen.mainScreen().currentMode?.size)

#else
    
var IOS8_OR_LATER = false
var IOS7_OR_LATER = false
var IOS6_OR_LATER = false
var IOS5_OR_LATER = false
var IOS4_OR_LATER = false
var IOS3_OR_LATER = false
    
var IOS7_OR_EARLIER = false
var IOS6_OR_EARLIER = false
var IOS5_OR_EARLIER = false
var IOS4_OR_EARLIER = false
var IOS3_OR_EARLIER = false
    
var IS_SCREEN_4_INCH = false
var IS_SCREEN_35_INCH = false
var IS_SCREEN_47_INCH = false
var IS_SCREEN_55_INCH = false
#endif


func OSVersion() ->String{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return UIDevice.currentDevice().systemName + " " + UIDevice.currentDevice().systemVersion
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return ""
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

func AppVersion() ->String{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    var value = NSBundle.mainBundle().infoDictionary["CFBundleVersion"]
    if nil == value || 0 == value.length
    {
    value = NSBundle.mainBundle().infoDictionary["CFBundleShortVersion"]
    }
    return value
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return ""
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

func AppIdentifier() ->String{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    var value = NSBundle.mainBundle().infoDictionary["CFBundleVersion"]
    if nil == value || 0 == value.length
    {
    value = NSBundle.mainBundle().infoDictionary["CFBundleShortVersion"]
    }
    return value
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return ""
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}





