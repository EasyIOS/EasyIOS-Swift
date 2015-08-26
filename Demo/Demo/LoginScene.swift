//
//  ViewController.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS

class LoginScene: EUScene {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBarButton(.LEFT, title: "返回", fontColor: UIColor.greenColor())
        
//        define("login"){
//            println("登陆回调")
//        }
        
        //在模拟器中调用下面这个方法可以生成一个加密文件
//        EUI.encode("LoginScene", suffix: "xml", toPath: "/Users/zhuchao/Desktop/EncodeLoginScene.crypto")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftButtonTouch() {
        URLNavigation.dismissCurrentAnimated(true)
    }
}

