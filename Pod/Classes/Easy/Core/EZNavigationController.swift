//
//  EZNavigationController.swift
//  medical
//
//  Created by zhuchao on 15/4/24.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

public class EZNavigationController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate{

    public var popGestureRecognizerEnabled = true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        weak var weekSelf = self
        self.interactivePopGestureRecognizer?.delegate = weekSelf
        self.delegate = weekSelf
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override public func  pushViewController(viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.enabled = false
        super.pushViewController(viewController, animated: animated)
    }
    
    //UINavigationControllerDelegate
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if self.popGestureRecognizerEnabled {
            self.interactivePopGestureRecognizer?.enabled = true
        }
    }
}
