//
//  Scene.swift
//  medical
//
//  Created by zhuchao on 15/4/22.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

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
        
    }
    
    func showBarButton(position:NAV,imageName:String){
        
    }
    
    func showBarButton(position:NAV,button:UIButton){
        
    }
    
    func leftButtonTouch(){
    
    }
    
    func rightButtonTouch(){
    
    }
    
    func setTitleView(titleView:UIView){
        
    }
    
    func addSubView(view:UIView,extend:EXTEND){
    
    }

    func addSubView(view:UIView,extend:EXTEND,inset:INSET){
        
    }
}
