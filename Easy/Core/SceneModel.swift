//
//  SceneModel.swift
//  medical
//
//  Created by zhuchao on 15/4/26.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

class SceneModel: NSObject {
    override init() {
        super.init()
    }
}

infix operator ->> {}
infix operator ~>> {}
infix operator ~|> {}
infix operator ~||> {}
infix operator |>> {}
infix operator <<| {}

//不使用缓存策略
func ->> (left:EZRequest,right:Bond<RequestState>) {
    left.useCache = false
    left.dataFromCache = false
    EZAction.Send(left)
    left.state *->> right
}

////使用缓存策略 但不从缓存读取
func ~>> (left:EZRequest,right:Bond<RequestState>) {
    left.useCache = true
    left.dataFromCache = false
    EZAction.Send(left)
    left.state *->> right
}

//使用缓存策略 仅首次读取缓存
func ~|> (left:EZRequest,right:Bond<RequestState>) {
    left.useCache = true
    left.dataFromCache = left.isFirstRequest
    EZAction.Send(left)
    left.state *->> right
}

//使用缓存策略 优先从缓存读取
func ~||> (left:EZRequest,right:Bond<RequestState>) {
    left.useCache = true
    left.dataFromCache = true
    EZAction.Send(left)
    left.state *->> right
}

//上传
func |>> (left:EZRequest,right:Bond<RequestState>) {
    EZAction.Upload(left)
    left.state *->> right
}

//下载
func <<| (left:EZRequest,right:Bond<RequestState>) {
    EZAction.Download(left)
    left.state *->> right
}
