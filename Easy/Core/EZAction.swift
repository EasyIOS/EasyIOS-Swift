//
//  Action.swift
//  medical
//
//  Created by zhuchao on 15/4/25.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import Async

var HOST_URL = "" //服务端域名:端口
var CLIENT = ""  //自定义客户端识别
var CODE_KEY = "" //错误码key,暂不支持路径 如 code
var RIGHT_CODE = 0  //正确校验码
var MSG_KEY = "" //消息提示msg,暂不支持路径 如 msg


class EZAction: NSObject {
    
    //使用缓存策略 仅首次读取缓存
    class func SEND_IQ_CACHE (left:EZRequest) {
        left.useCache = true
        left.dataFromCache = left.isFirstRequest
        EZAction.Send(left)
    }
    
    //使用缓存策略 优先从缓存读取
    class func SEND_CACHE (left:EZRequest) {
        left.useCache = true
        left.dataFromCache = true
        self.Send(left)
    }
    
    //不使用缓存策略
    class func SEND (left:EZRequest) {
        left.useCache = false
        left.dataFromCache = false
        EZAction.Send(left)
    }
    
    
    class func Send (req :EZRequest){
        var url = ""
        var requestParams = Dictionary<String,AnyObject>()
        
        if !isEmpty(req.staticPath) {
            url = req.staticPath
        }else{
            if isEmpty(req.scheme) {
                req.scheme = "http"
            }
            if isEmpty(req.host) {
                req.host = HOST_URL
            }
            url = req.scheme + "://" + req.host + req.path
            if  isEmpty(req.appendPathInfo) {
                requestParams = req.requestParams
            }else{
                url = url + req.appendPathInfo
            }
        }
        req.state.value = .Sending
        req.op = Alamofire.request(req.method, url, parameters: requestParams, encoding: req.parameterEncoding)
            .validate(statusCode: 200..<300)
            .validate(contentType: req.acceptableContentTypes)
            .responseString { (_, _, string, _) in
                req.responseString = string!
            }.responseJSON { (_, _, json, error)  in
                if error != nil{
                    req.error = error
                    self.failed(req)
                }else{
                    req.output = json as! Dictionary<String, AnyObject>
                    self.checkCode(req)
                }
            }
        req.url = req.op?.request.URL
        self.getCacheJson(req)
    }
    
    class func Upload (req :EZRequest){
        req.state.value = .Sending
        req.op = Alamofire.upload(.POST, req.downloadUrl, req.uploadData!)
            .validate(statusCode: 200..<300)
            .validate(contentType: req.acceptableContentTypes)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                req.totalBytesWritten = Double(totalBytesWritten)
                req.totalBytesExpectedToWrite = Double(totalBytesExpectedToWrite)
                req.progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            }
            .responseString { (_, _, string, _) in
                req.responseString = string!
            }.responseJSON { (_, _, json, error) in
                if error != nil{
                    req.error = error
                    self.failed(req)
                }else{
                    req.output = json as! Dictionary<String, AnyObject>
                    self.checkCode(req)
                }
            }
        req.url = req.op?.request.URL
    }
    
    class func Download (req :EZRequest){
        req.state.value = .Sending
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)

        req.op = Alamofire.download(.GET, req.downloadUrl, { (temporaryURL, response) in
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
                    inDomains: .UserDomainMask)[0]
                as? NSURL {
                    return directoryURL.URLByAppendingPathComponent(req.targetPath + response.suggestedFilename!)
            }
            return temporaryURL
        })
            .validate(statusCode: 200..<300)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                req.totalBytesRead = Double(totalBytesRead)
                req.totalBytesExpectedToRead = Double(totalBytesExpectedToRead)
                req.progress = Double(totalBytesRead) / Double(totalBytesExpectedToRead)
            }
            .response { (request, response, _, error) in
                if error != nil{
                    req.error = error
                    self.failed(req)
                }else{
                    req.responseString = "\(response)"
                    req.state.value = .Success
                }
            }
        req.url = req.op?.request.URL
    }
    
    private class func cacheJson (req: EZRequest) {
        if req.useCache {
            let cache = Shared.JSONCache
            cache.set(value:.Dictionary(req.output) , key: req.cacheKey)
        }
    }
    
    private class func getCacheJson (req: EZRequest) {
        let cache = Shared.JSONCache
        cache.fetch(key: req.cacheKey).onSuccess { JSON in
            req.output = JSON.dictionary
        }
        
        if req.dataFromCache && !isEmpty(req.output) {
            Async.main(after: 0.1, block: {
                self.successFromCache(req)
            })
        }
    }
    
    private class func successFromCache (req: EZRequest){
        if req.needCheckCode {
            req.codeKey = req.output[CODE_KEY] as! Int
            if req.codeKey == RIGHT_CODE {
                req.message = req.output[MSG_KEY] as! String
                req.state.value = .SuccessFromCache
            }else{
                self.error(req)
            }
        }
    }
    
    private class func checkCode (req: EZRequest) {
        if req.needCheckCode {
            req.codeKey = req.output[CODE_KEY] as! Int
            if req.codeKey == RIGHT_CODE {
                self.success(req)
                self.cacheJson(req)
            }else{
                self.error(req)
            }
        }else{
            req.state.value = .Success
            self.cacheJson(req)
        }
    }

    
    private class func success (req: EZRequest) {
        req.isFirstRequest = false
        req.message = req.output[MSG_KEY] as! String
        if isEmpty(req.output) {
            req.state.value = .Error
        }else{
            req.state.value = .Success
        }
    }
    
    private class func failed (req: EZRequest) {
        req.message = req.error?.userInfo?["NSLocalizedDescription"] as! String
        req.state.value = .Failed
        EZPrintln(req.message)
    }
    
    private class func error (req: EZRequest) {
        req.message = req.output[MSG_KEY] as! String
        req.state.value = .Error
        EZPrintln(req.message)
    }
    
}


