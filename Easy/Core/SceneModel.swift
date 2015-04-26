//
//  SceneModel.swift
//  medical
//
//  Created by zhuchao on 15/4/26.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

class SceneModel: NSObject {
    var action = EZAction()
    override init() {
        super.init()
        self.loadSceneModel()
    }
    
    func loadSceneModel (){
    
    }
}

infix operator ->> {}
infix operator ~>> {}
infix operator ~|> {}
infix operator ~||> {}
infix operator |>> {}
infix operator <<| {}

//不使用缓存策略
func ->> (left:EZRequest , right:EZAction ) {
    if !isEmpty(left) || !isEmpty(right) {
        left.useCache = false
        left.dataFromCache = false
        right.Send(left)
    }
}

//使用缓存策略 但不从缓存读取
func ~>> (left:EZRequest , right:EZAction ) {
    if !isEmpty(left) && !isEmpty(right) {
        left.useCache = true
        left.dataFromCache = false
        right.Send(left)
    }
}

//使用缓存策略 仅首次读取缓存
func ~|> (left:EZRequest , right:EZAction ) {
    if !isEmpty(left) && !isEmpty(right) {
        left.useCache = true
        left.dataFromCache = left.isFirstRequest
        right.Send(left)
    }
}

//使用缓存策略 优先从缓存读取
func ~||> (left:EZRequest , right:EZAction ) {
    if !isEmpty(left) && !isEmpty(right) {
        left.useCache = true
        left.dataFromCache = true
        right.Send(left)
    }
}

//上传
func |>> (left:EZRequest , right:EZAction ) {
    if !isEmpty(left) && !isEmpty(right) {
        right.Upload(left)
    }
}

//下载
func <<| (left:EZRequest , right:EZAction ) {
    if !isEmpty(left) && !isEmpty(right) {
        right.Download(left)
    }
}
