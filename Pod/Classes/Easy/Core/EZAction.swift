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
import Bond

public var HOST_URL = "" //服务端域名:端口
public var CLIENT = ""  //自定义客户端识别
public var CODE_KEY = "" //错误码key,暂不支持路径 如 code
public var RIGHT_CODE = 0  //正确校验码
public var MSG_KEY = "" //消息提示msg,暂不支持路径 如 msg


private var networkReachabilityHandle: UInt8 = 2;
public class EZAction: NSObject {
    
    //使用缓存策略 仅首次读取缓存
    public class func SEND_IQ_CACHE (left:EZRequest) {
        left.useCache = true
        left.dataFromCache = left.isFirstRequest
        EZAction.Send(left)
    }
    
    //使用缓存策略 优先从缓存读取
    public class func SEND_CACHE (left:EZRequest) {
        left.useCache = true
        left.dataFromCache = true
        self.Send(left)
    }
    
    //不使用缓存策略
    public class func SEND (left:EZRequest) {
        left.useCache = false
        left.dataFromCache = false
        EZAction.Send(left)
    }
    
    
    public class func Send (req :EZRequest){
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
                req.responseString = string
            }.responseJSON { (_, _, json, error)  in
                if json == nil{
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
    
    public class func Upload (req :EZRequest){
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
    
    public class func Download (req :EZRequest){
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
            cache.set(value: .Dictionary(req.output), key: req.cacheKey, formatName: HanekeGlobals.Cache.OriginalFormatName){ JSON in
                EZPrintln("Cache Success for key: \(req.cacheKey)")
            }
        }
    }
    
    private class func getCacheJson (req: EZRequest) {
        let cache = Shared.JSONCache
        cache.fetch(key: req.cacheKey).onSuccess { JSON in
            req.output = JSON.dictionary
            if req.dataFromCache && !isEmpty(req.output) {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                    Int64(0.1 * Double(NSEC_PER_SEC)))
            
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.loadFromCache(req)
                }
            }
        }
    }
    
    private class func loadFromCache (req: EZRequest){
        if req.needCheckCode && req.state.value != .Success {
            req.codeKey = req.output[CODE_KEY] as? Int
            if req.codeKey == RIGHT_CODE {
                req.message = req.output[MSG_KEY] as? String
                req.state.value = .SuccessFromCache
                EZPrintln("Fetch  Success from Cache by key: \(req.cacheKey)")
            }else{
                req.message = req.output[MSG_KEY] as? String
                req.state.value = .ErrorFromCache
                EZPrintln(req.message)
            }
        }
    }
    
    private class func checkCode (req: EZRequest) {
        if req.needCheckCode {
            req.codeKey = req.output[CODE_KEY] as? Int
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
        req.message = req.output[MSG_KEY] as? String
        if isEmpty(req.output) {
            req.state.value = .Error
        }else{
            req.state.value = .Success
        }
    }
    
    private class func failed (req: EZRequest) {
        req.message = req.error?.userInfo?["NSLocalizedDescription"] as? String
        req.state.value = .Failed
        EZPrintln(req.message)
    }
    
    private class func error (req: EZRequest) {
        req.message = req.output[MSG_KEY] as? String
        req.state.value = .Error
        EZPrintln(req.message)
    }
    
    /* Usage
    EZAction.networkReachability *->> Bond<NetworkStatus>{ status in
        switch (status) {
        case .NotReachable:
        EZPrintln("NotReachable")
        case .ReachableViaWiFi:
        EZPrintln("ReachableViaWiFi")
        case .ReachableViaWWAN:
        EZPrintln("ReachableViaWWAN")
        default:
        EZPrintln("default")
        }
    }
    */
    public class var networkReachability: InternalDynamic<NetworkStatus> {
        if let d: AnyObject = objc_getAssociatedObject(self, &networkReachabilityHandle) {
            return (d as? InternalDynamic<NetworkStatus>)!
        } else {
            let reachability = Reachability.reachabilityForInternetConnection()
            let d = InternalDynamic<NetworkStatus>(reachability.currentReachabilityStatus)
            reachability.whenReachable = { reachability in
                d.value = reachability.currentReachabilityStatus
            }
            reachability.whenUnreachable = { reachability in
                d.value = reachability.currentReachabilityStatus
            }
            reachability.startNotifier()
            objc_setAssociatedObject(self, &networkReachabilityHandle, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
}


