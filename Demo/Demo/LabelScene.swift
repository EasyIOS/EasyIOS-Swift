//
//  LabelScene.swift
//  Demo
//
//  Created by zhuchao on 15/5/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import EasyIOS
import TTTAttributedLabel

class LabelScene: EUScene {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBarButton(.LEFT, title: "返回", fontColor: UIColor.greenColor())
        self.title = "界面里只有1个Label"
        
        
        if let label = getElementById("labelId") as? TTTAttributedLabel {
            //do someting
        }
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func eu_viewWillLoad() {
        self.attributedLabelDelegate = MainLabelDeleage()
    }
    
    override func leftButtonTouch() {
        URLNavigation.dismissCurrentAnimated(true)
    }
}

