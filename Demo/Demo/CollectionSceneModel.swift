//
//  CollectionCellViewModel.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS
import Bond

class CollectionSceneModel: EZSceneModel {

    var dataArray =  DynamicArray<CollectionCellViewModel>(Array<CollectionCellViewModel>())
    override init (){
        super.init()
        
        for var i = 0;i<100;i++ {
            self.dataArray.append(CollectionCellViewModel(imageUrl: "http://d.hiphotos.baidu.com/zhidao/pic/item/562c11dfa9ec8a13e028c4c0f603918fa0ecc0e4.jpg"))
        }
        
    }
}
