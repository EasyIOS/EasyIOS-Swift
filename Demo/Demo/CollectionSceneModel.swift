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
    
    required init?(_ map: Map){
        
    }

    func mapping(map: Map) {
        url    <- map["url"]
        name   <- map["name"]
    }
}

class FeedList:Mappable {
    var list:[FeedModel]?
    
    required init?(_ map: Map){
        
    }

    func mapping(map: Map) {
        list <- map["list"]
    }
}

class CollectionSceneModel: EZSceneModel {
    var req = FeedRequest()
    var modelList:FeedList?
    
    var viewModelList =  ObservableArray<CollectionCellViewModel>([CollectionCellViewModel]())
    override init (){
        super.init()
    
        self.req.requestBlock = {
            EZAction.SEND_IQ_CACHE(self.req)
        }
        self.req.state.observe{[unowned self] value in
            switch value {
            case .Success,.SuccessFromCache :
                if let theData: AnyObject = self.req.output["data"] {
                    
                    self.modelList = Mapper<FeedList>().map(theData)
                    if let array = self.modelList?.list?.map({
                        (model) -> CollectionCellViewModel in
                        return CollectionCellViewModel(url: model.url, name: model.name)
                    }) {
                        self.viewModelList.removeAll()
                        self.viewModelList.extend(array)
                    }
                }
            default :
                return
            }
        }
    }
}
