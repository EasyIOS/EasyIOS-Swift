//
//  FeedRequest.swift
//  Demo
//
//  Created by zhuchao on 15/5/14.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS

class FeedRequest: EZRequest {
    
    //如果不使用staticPath，可以设置如下参数，同OC版本的使用方法
    
//    var feedId:String?
//    var type:String?
    
    override init() {
        super.init()
        self.staticPath = "http://7tsz2s.com1.z0.glb.clouddn.com/feedlists.txt"
        
    }
}
