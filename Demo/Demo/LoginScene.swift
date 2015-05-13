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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func login (){
        self.navigationController?.navigationBar.hidden = true
        if let nav = self.navigationController as? EZNavigationController {
            nav.popGestureRecognizerEnabled = false
        }
//        URLNavigation.pushViewController(TabBarScene(), animated: true)
    }
}

