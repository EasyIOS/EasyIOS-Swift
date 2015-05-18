//
//  MainScene.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

import Bond
import EasyIOS

class MainScene: EUScene,UITableViewDelegate{
    var sceneModel = MainSceneModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EasyIOS"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //接收xml里的下拉刷新事件
    func handlePullRefresh (tableView:UITableView){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            tableView.pullToRefreshView?.stopAnimating()
        }
    }
    
    //do someThing init before loadTheView
    override func eu_viewWillLoad() {
        self.attributedLabelDelegate = MainLabelDeleage()
    }
    
    override func eu_tableViewDidLoad(tableView:UITableView?){
        tableView?.delegate = self
        self.sceneModel.dataArray.map { (data:MainCellViewModel) -> UITableViewCell in
            let cell = tableView!.dequeueReusableCell("cell", target: self,bind:data) as UITableViewCell
            cell.selectionStyle = .None
            return cell
        } ->> self.eu_tableViewDataSource!
    }
    
    func click(){
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var model = self.sceneModel.dataArray[indexPath.row]
        if let link = model.link {
            URLManager.pushURLString(link, animated: true)
        }
    }
}
