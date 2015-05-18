//
//  MainCellViewModel.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS

class MainCellViewModel: EZViewModel {
    var title:String?
    var subTitle:NSData?
    var srcUrl:NSURL?
    var link:String?
    init(title:String,subTitle:String = "",srcUrl:String = "",link:String = ""){
        self.title = title
        if let data = subTitle.toData() {
            self.subTitle = data
        }
        self.srcUrl = NSURL(string: srcUrl)
        self.link = link
    }
}
