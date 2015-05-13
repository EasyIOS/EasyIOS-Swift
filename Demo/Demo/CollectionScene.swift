//
//  CollectionScene.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS
import Bond

class CollectionScene: EUScene {

    var sceneModel = CollectionSceneModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func eu_collectionViewDidLoad(collectionView: UICollectionView?) {
        self.sceneModel.dataArray.map { (data:CollectionCellViewModel,index:Int) -> UICollectionViewCell in
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let cell = collectionView!.dequeueReusableCell("cell",forIndexPath:indexPath, target: self,bind:data) as UICollectionViewCell
            return cell
            } ->> self.eu_collectionViewDataSource!
    }

}
