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
import SVProgressHUD

class CollectionScene: EUScene,UICollectionViewDelegate {

    var sceneModel = CollectionSceneModel()
    var collectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBarButton(.LEFT, title: "返回", fontColor: UIColor.greenColor())
        self.sceneModel.req.requestNeedActive.value = true
        
        self.sceneModel.req.state.observe{
            switch $0 {
            case .Sending :
                SVProgressHUD.show()
            case .Success,.SuccessFromCache :
                SVProgressHUD.dismiss()
                self.collectionView?.pullToRefreshView?.stopAnimating()
            case .Error :
                SVProgressHUD.showErrorWithStatus("数据加载失败")
            default :
                return
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func eu_collectionViewDidLoad(collectionView: UICollectionView?) {
        self.collectionView = collectionView
        collectionView?.delegate = self
        
        
        define("handlePullRefresh"){
            self.sceneModel.req.requestNeedActive.value = true
        }
        
        define("handleInfinite"){
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(3.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.collectionView?.infiniteScrollingView?.stopAnimating()
                self.collectionView?.infiniteScrollingView?.setEnded()
            }
        }
        
        self.sceneModel.viewModelList.lift().bindTo(collectionView!) { (indexPath, dataArray, collectionView) -> UICollectionViewCell in
            collectionView.dequeueReusableCell("cell",
                forIndexPath: indexPath,
                target: self,
                bind: dataArray[indexPath.section][indexPath.row])
        }
    }

    override func leftButtonTouch() {
        URLNavigation.dismissCurrentAnimated(true)
    }
}
