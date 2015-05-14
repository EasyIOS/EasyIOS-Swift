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

    var url:EZString?
    var name:EZString?
    init(url:String?,name:String?){
        if url != nil {
            self.url = EZString(url!)
        }
        if name != nil {
            self.name = EZString(name!)
        }
    }
}
