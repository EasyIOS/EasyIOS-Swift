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
        self.configGestureRecognizer()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func configGestureRecognizer() {
        if let target = self.interactivePopGestureRecognizer?.delegate {
            let pan = UIPanGestureRecognizer(target: target, action: Selector("handleNavigationTransition:"))
            pan.delegate = self
            self.view.addGestureRecognizer(pan)
        }
        //禁掉系统的侧滑手势
        weak var weekSelf = self
        self.interactivePopGestureRecognizer?.enabled = false;
        self.interactivePopGestureRecognizer?.delegate = weekSelf;
    }

    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != self.interactivePopGestureRecognizer && self.viewControllers.count > 1 && self.popGestureRecognizerEnabled{
            return true
        }else{
            return false
        }
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
