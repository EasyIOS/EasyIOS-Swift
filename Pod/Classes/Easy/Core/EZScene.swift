//
//  Scene.swift
//  medical
//
//  Created by zhuchao on 15/4/22.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import SnapKit

public enum NAV : Int {
    case LEFT
    case RIGHT
}

public enum EXTEND : Int{
    case NONE
    case TOP
    case BOTTOM
    case TOP_BOTTOM
}

public enum INSET : Int{
    case NONE
    case TOP
    case BOTTOM
    case TOP_BOTTOM
}

public class EZScene: UIViewController {
    
    //parentScene 保留设计，必要的时候保存parentScene
    public weak var parentScene:EZScene?

    //导航条左右按钮设置 NAV是一个枚举值：.LEFT,.RIGHT
    public func showBarButton(position:NAV,title:String,fontColor:UIColor){
        self.showBarButton(position, button: UIButton(navTitle: title, color: fontColor))
    }
    
    public func showBarButton(position:NAV,imageName:String) -> Void{
        self.showBarButton(position, button: UIButton(navImage: UIImage(named: imageName)!))
    }
    
    public func showBarButton(position:NAV,button:UIButton?){
        if position == .LEFT {
            button?.addTarget(self, action: Selector("leftButtonTouch"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button!)
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }else if position == .RIGHT {
            button?.addTarget(self, action: Selector("rightButtonTouch"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button!)
        }
    }
    
    public func leftButtonTouch(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    public func rightButtonTouch(){
        
    }
    
    public func setTitleView(titleView:UIView){
        self.navigationItem.titleView = titleView
    }
    
    public func addSubView(view:UIView,extend:EXTEND){
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.All
        view.snp_makeConstraints { (make) -> Void in
            //TODO
//            make.edges.equalTo(view.superview!).inset(
//                EdgeInsetsMake((extend == EXTEND.TOP||extend == EXTEND.TOP_BOTTOM) ? 64:0, left:0,bottom:(extend == EXTEND.BOTTOM||extend == EXTEND.TOP_BOTTOM) ? 49:0, right: 0)
//            )
        }
    }

    public func addScrollView(view:UIScrollView,extend:EXTEND,inset:INSET){
        self.addSubView(view, extend: extend)
//        view.contentInset = UIEdgeInsetsMake((inset == INSET.TOP || inset == INSET.TOP_BOTTOM) ? 64:0, 0,
//            (inset == INSET.BOTTOM || inset == INSET.TOP_BOTTOM) ? 49:0, 0)
    }
    
    

}
