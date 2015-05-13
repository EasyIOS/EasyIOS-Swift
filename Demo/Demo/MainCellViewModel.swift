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
    var title:EZString?
    var subTitle:EZString?
    var srcUrl:EZURL?
    var link:EZString?
    init(title:String,subTitle:String = "",srcUrl:String = "",link:String = ""){
        self.title = EZString(title)
        self.subTitle = EZString(subTitle)
        self.srcUrl = EZURL(NSURL(string: srcUrl))
        self.link = EZString(link)
    }
}
