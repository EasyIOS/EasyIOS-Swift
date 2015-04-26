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
    
    func Send (req :EZRequest){
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
        self.sending(req)
        req.op = Alamofire.request(req.method, url, parameters: requestParams, encoding: req.parameterEncoding)
            .validate(statusCode: 200..<300)
            .validate(contentType: req.acceptableContentTypes)
            .responseString { (_, _, string, _) in
                req.responseString = string!
            }.responseJSON { [unowned self] (_, _, json, error)  in
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
    
    func Upload (req :EZRequest){
        self.sending(req)
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
    
    func Download (req :EZRequest){
        self.sending(req)
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
                    self.successAction(req)
                }
            }
        req.url = req.op?.request.URL
    }
    
    private func cacheJson (req: EZRequest) {
        if req.useCache {
            let cache = Shared.JSONCache
            cache.set(value:.Dictionary(req.output) , key: req.cacheKey)
        }
    }
    
    private func getCacheJson (req: EZRequest) {
        let cache = Shared.JSONCache
        cache.fetch(key: req.cacheKey).onSuccess { JSON in
            req.output = JSON.dictionary
        }
        
        if req.dataFromCache && !isEmpty(req.output) {
            Async.main(after: 0.1, block: {
                self.checkCode(req)
            })
        }
    }
    
    private func checkCode (req: EZRequest) {
        if req.needCheckCode {
            req.codeKey = req.output[CODE_KEY] as! Int
            if req.codeKey == RIGHT_CODE {
                self.success(req)
                self.cacheJson(req)
            }else{
                self.error(req)
            }
        }else{
            self.successAction(req)
            self.cacheJson(req)
        }
    }
    
    private func sending (req: EZRequest) {
        req.state = RequestState.Sending
    }
    
    private func success (req: EZRequest) {
        req.isFirstRequest = false
        req.message = req.output[MSG_KEY] as! String
        self.successAction(req)
    }
    
    private func successAction (req: EZRequest) {
        req.state = RequestState.Success
    }
    
    private func failed (req: EZRequest) {
        req.message = req.error?.userInfo?["NSLocalizedDescription"] as! String
        req.state = RequestState.Failed
        println(req.message)
    }
    
    private func error (req: EZRequest) {
        req.message = req.output[MSG_KEY] as! String
        req.state = RequestState.Error
        println(req.message)
    }
    
}


