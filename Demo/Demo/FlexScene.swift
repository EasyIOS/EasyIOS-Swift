//
//  FlexScene.swift
//  Demo
//
//  Created by zhuchao on 15/10/14.
//  Copyright © 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS

class FlexScene: EZScene {
    var container:FLEXBOXContainerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container  = FLEXBOXContainerView(frame: self.view.bounds)
        container.flexJustifyContent = FLEXBOXJustification.Center
        container.flexAlignItems = FLEXBOXAlignment.Center
        container.flexDirection = FLEXBOXFlexDirection.Column
//        container.flexMinimumSize = CGSizeMake(100, 200)
//        container.flexPadding = UIEdgeInsetsMake(10, 10, 10, 10)
//        container.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        container.backgroundColor = UIColor.grayColor()
        
        
        let v1 = UILabel()
        v1.text = "123123"
        v1.backgroundColor = UIColor.blueColor()
        v1.textAlignment = NSTextAlignment.Center
        v1.flexMargin = UIEdgeInsetsMake(8, 8, 8, 8)
        v1.flexPadding = UIEdgeInsetsMake(10, 10, 10, 10)
        v1.flex = 0
//        v1.flexFixedSize = CGSizeZero
//        v1.flexMaximumSize  = CGSizeMake(CGFloat.max, CGFloat.max)
        
        container.addSubview(v1)
        
        let v2 = UILabel()
        v2.text = "321"
        v2.backgroundColor = UIColor.blueColor()
        v2.textAlignment = NSTextAlignment.Center
        v2.flexMargin = UIEdgeInsetsMake(8, 8, 8, 8)
        v2.flexPadding = UIEdgeInsetsMake(10, 10, 10, 10)
        v2.flex = 0
        
//        v2.flexFixedSize = CGSizeZero
//        v2.flexMaximumSize  = CGSizeMake(CGFloat.max, CGFloat.max)
        
        container.addSubview(v2)
        
        
        self.view.addSubview(container)
        
    }
}
