//
//  EUScene.swift
//  medical
//
//  Created by zhuchao on 15/5/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import JavaScriptCore

public var LIVE_LOAD_PATH = NSBundle.mainBundle().pathForResource("xml", ofType: "bundle")!
public var BUNDLE_PATH = NSBundle.mainBundle().pathForResource("xml", ofType: "bundle")!

public var CRTPTO_KEY = ""


@objc protocol EUSceneExport:JSExport {
    func getElementById(id:String) -> UIView
}

public class EUScene: EZScene,EUSceneExport{
    
    
    public func getElementById(id:String) -> UIView {
        return UIView.formTag(id)
    }
    
    public var SUFFIX = "xml"
    public var eu_subViews:[UIView]?
    public var scriptString:String?
    
    public var context = EZJSContext()
    
    public func define(funcName:String,actionBlock:@convention(block) ()->Void){
        context.define(funcName, actionBlock: actionBlock)
    }
    
    public func eval(script: String?) -> JSValue?{
        if let str =  script {
            var result:JSValue?
            SwiftTryCatch.`try`({
                result = self.context.evaluateScript(str)
                }, `catch`: { (error) in
                    print("JS Error:\(error.description)")
                }, finally: nil)
            return result
        }else{
            return nil
        }
    }
    
    override public func loadView() {
        super.loadView()
        EUI.setLiveLoad(self,suffix: SUFFIX)
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.extendedLayoutIncludesOpaqueBars = true;
        self.edgesForExtendedLayout = UIRectEdge.All;
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadEZLayout()
    }
    
    public func eu_viewWillLoad(){
    
    }
    
    public func eu_viewDidLoad(){

    }

    public func eu_tableViewDidLoad(tableView:UITableView?){
        
    }
    
    public func eu_collectionViewDidLoad(collectionView:UICollectionView?){
        
    }

    
}
