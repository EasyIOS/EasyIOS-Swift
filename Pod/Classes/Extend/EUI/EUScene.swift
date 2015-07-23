//
//  EUScene.swift
//  medical
//
//  Created by zhuchao on 15/5/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import JavaScriptCore

public var LIVE_LOAD_PATH = __FILE__.stringByDeletingLastPathComponent
public var CRTPTO_KEY = ""


@objc protocol EUSceneExport:JSExport,ENSObject {
    func getElementById(id:String) -> UIView
}

public class EUScene: EZScene,EUSceneExport{
    public var SUFFIX = "xml"
    public var eu_subViews:[UIView]?
    public var scriptString:String?
    
    public var context = EZJSContext()
    
    public func define(funcName:String,actionBlock:@objc_block ()->Void){
        context.define(funcName, actionBlock: actionBlock)
    }
    
    public func eval(script: String?) -> JSValue?{
        var result:JSValue?
        SwiftTryCatch.try({
            result = self.context.evaluateScript(script)
            }, catch: { (error) in
                println("JS Error:\(error.description)")
            }, finally: nil)
        return result
    }
    
    override public func loadView() {
        super.loadView()
        EUI.setLiveLoad(LIVE_LOAD_PATH, controller:self,suffix: SUFFIX)
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
    
    public func getElementById(id:String) -> UIView {
        return UIView.formTag(id)
    }
    
}
