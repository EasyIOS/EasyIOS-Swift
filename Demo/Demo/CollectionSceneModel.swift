//
//  CollectionCellViewModel.swift
//  Demo
//
//  Created by zhuchao on 15/5/13.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import EasyIOS
import Bond
import ObjectMapper

class FeedModel :Mappable{
    var url:String?
    var name:String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        url    <- map["url"]
        name   <- map["name"]
    }
}

class FeedList:Mappable {
    var list:[FeedModel]?
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        list <- map["list"]
    }
}

class CollectionSceneModel: EZSceneModel {
    var req = FeedRequest()
    var modelList:FeedList?
    
    var viewModelList =  DynamicArray<CollectionCellViewModel>(Array<CollectionCellViewModel>())
    override init (){
        super.init()
        
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.HTTPAdditionalHeaders  = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]

        
        self.req.sessionConfiguration = configuration
        
        self.req.requestBlock = {
            EZAction.SEND_IQ_CACHE(self.req)
        }
        self.req.state *->> Bond<RequestState>(){[unowned self] value in
            switch value {
            case .Success,.SuccessFromCache :
                if let theData: AnyObject = self.req.output["data"] {
                    
                    self.modelList = Mapper<FeedList>().map(theData)
                    
                    if let array = self.modelList?.list?.map({
                        (model) -> CollectionCellViewModel in
                        return CollectionCellViewModel(url: model.url, name: model.name)
                    }) {
                        self.viewModelList.removeAll(true)
                        self.viewModelList.append(array)
                    }
                }
            default :
                return
            }
        }
    }
}
