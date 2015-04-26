//
//  Scene.swift
//  medical
//
//  Created by zhuchao on 15/4/22.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Cartography

enum NAV : Int {
    case LEFT
    case RIGHT
}

enum EXTEND : Int{
    case NONE
    case TOP
    case BOTTOM
    case TOP_BOTTOM
}

enum INSET : Int{
    case NONE
    case TOP
    case BOTTOM
    case TOP_BOTTOM
}

class Scene: UIViewController {

    var parentScene:Scene?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showBarButton(position:NAV,title:String,fontColor:UIColor){
        self.showBarButton(position, button: UIButton(navTitle: title, color: fontColor))
    }
    
    func showBarButton(position:NAV,imageName:String) -> Void{
        self.showBarButton(position, button: UIButton(navImage: UIImage(named: imageName)!))
    }
    
    func showBarButton(position:NAV,button:UIButton?){
        if position == .LEFT {
            button?.addTarget(self, action: Selector("leftButtonTouch"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button!)
            self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        }else if position == .RIGHT {
            button?.addTarget(self, action: Selector("rightButtonTouch"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button!)
        }
    }
    
    func leftButtonTouch(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightButtonTouch(){
        
    }
    
    func setTitleView(titleView:UIView){
        self.navigationItem.titleView = titleView
    }
    
    func addSubView(view:UIView,extend:EXTEND){
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.All
        layout(view) { view in
            view.edges == inset(view.superview!.edges,
                (extend == .TOP||extend == .TOP_BOTTOM) ? 64:0, 0,
                (extend == .BOTTOM||extend == .TOP_BOTTOM) ? 49:0, 0)
        }
    }

    func addScrollView(view:UIScrollView,extend:EXTEND,inset:INSET){
        self.addSubView(view, extend: extend)
        view.contentInset = UIEdgeInsetsMake((inset == .TOP || inset == .TOP_BOTTOM) ? 64:0, 0,
            (inset == .BOTTOM || inset == .TOP_BOTTOM) ? 49:0, 0)
    }
}
