//
//  CollectionCellViewModel.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS

class CollectionCellViewModel: EZViewModel {

    var srcUrl:EZURL?
    init(imageUrl:String){
        self.srcUrl = EZURL(NSURL(string: imageUrl))
        
    }
}
