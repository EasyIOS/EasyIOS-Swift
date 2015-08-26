//
//  EncodeLoginScene.swift
//  Demo
//
//  Created by zhuchao on 15/5/26.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import EasyIOS

class EncodeLoginScene: EUScene {
    
    override func loadView() {
        self.SUFFIX = "crypto"  //修改后缀为加密版本的
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBarButton(.LEFT, title: "返回", fontColor: UIColor.greenColor())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftButtonTouch() {
        URLNavigation.dismissCurrentAnimated(true)
    }
    
}

