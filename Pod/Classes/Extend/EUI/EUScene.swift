//
//  EUScene.swift
//  medical
//
//  Created by zhuchao on 15/5/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

public var LIVE_LOAD_PATH = __FILE__.stringByDeletingLastPathComponent

public var CRTPTO_KEY = ""

public class EUScene: EZScene {
    public var SUFFIX = "xml"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.extendedLayoutIncludesOpaqueBars = true;
        self.edgesForExtendedLayout = UIRectEdge.All;
        EUI.setLiveLoad(LIVE_LOAD_PATH, controller:self,suffix: SUFFIX)
    }


    public func eu_tableViewDidLoad(tableView:UITableView?){
        
    }
    
    public func eu_collectionViewDidLoad(collectionView:UICollectionView?){
        
    }
}
