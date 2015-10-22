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
import ReachabilitySwift

public var HOST_URL = "" //服务端域名:端口
public var CODE_KEY = "" //错误码key,暂不支持路径 如 code
public var RIGHT_CODE = 0  //正确校验码
public var MSG_KEY = "" //消息提示msg,暂不支持路径 如 msg


private var networkReachabilityHandle: UInt8 = 2;

public class EZAction: NSObject {
    
    //使用缓存策略 仅首次读取缓存
    public class func SEND_IQ_CACHE (req:EZRequest) {
        req.useCache = true
        req.dataFromCache = req.isFirstRequest
        self.Send(req)
    }
    
    //使用缓存策略 优先从缓存读取
    public class func SEND_CACHE (req:EZRequest) {
        req.useCache = true
        req.dataFromCache = true
        self.Send(req)
    }
    
    //不使用缓存策略
    public class func SEND (req:EZRequest) {
        req.useCache = false
        req.dataFromCache = false
        self.Send(req)
    }
    
    
    public class func Send (req :EZRequest){
        var url = ""
        var requestParams = Dictionary<String,AnyObject>()
        
        if !req.staticPath.characters.isEmpty {
            url = req.staticPath
        }else{
            if req.scheme.characters.isEmpty {
                req.scheme = "http"
            }
            if req.host.characters.isEmpty {
                req.host = HOST_URL
            }
            url = req.scheme + "://" + req.host + req.path
            if  req.appendPathInfo.characters.isEmpty {
                requestParams = req.requestParams
            }else{
                url = url + req.appendPathInfo
            }
        }
        req.state.value = RequestState.Sending
        
        req.op = req.manager
            .request(req.method, url, parameters: requestParams, encoding: req.parameterEncoding)
            .validate(statusCode: 200..<300)
            .validate(contentType: req.acceptableContentTypes)
            .responseJSON { response  in
                 req.response = response
                if response.result.isFailure{
                    req.error = response.result.error
                    self.failed(req)
                }else{
                    req.output = response.result.value as! Dictionary<String, AnyObject>
                    self.checkCode(req)
                }
            }
        req.url = req.op?.request!.URL
        self.getCacheJson(req)
    }
    
    public class func Upload (req :EZRequest){
        req.state.value = RequestState.Sending
        req.op = req.manager
            .upload(.POST, req.uploadUrl, data: req.uploadData!)
            .validate(statusCode: 200..<300)
            .validate(contentType: req.acceptableContentTypes)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                req.totalBytesWritten = Double(totalBytesWritten)
                req.totalBytesExpectedToWrite = Double(totalBytesExpectedToWrite)
                req.progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            }.responseJSON { response in
                req.response = response
                if response.result.isFailure{
                    req.error = response.result.error
                    self.failed(req)
                }else{
                    req.output = response.result.value as! Dictionary<String, AnyObject>
                    self.checkCode(req)
                }
            }
        req.url = req.op?.request!.URL
    }
    
    public class func Download (req :EZRequest){
        req.state.value = RequestState.Sending
        req.op = req.manager
            .download(.GET, req.downloadUrl, destination: { (temporaryURL, response) in
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
                    inDomains: .UserDomainMask)[0]
            return directoryURL.URLByAppendingPathComponent(req.targetPath + response.suggestedFilename!)
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
                    req.state.value = RequestState.Success
                }
            }
        req.url = req.op?.request!.URL
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
                req.state.value = RequestState.SuccessFromCache
                EZPrintln("Fetch  Success from Cache by key: \(req.cacheKey)")
            }else{
                req.message = req.output[MSG_KEY] as? String
                req.state.value = RequestState.ErrorFromCache
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
            req.state.value = RequestState.Success
            self.cacheJson(req)
        }
    }

    
    private class func success (req: EZRequest) {
        req.isFirstRequest = false
        req.message = req.output[MSG_KEY] as? String
        if req.output.isEmpty {
            req.state.value = RequestState.Error
        }else{
            req.state.value = RequestState.Success
        }
    }
    
    private class func failed (req: EZRequest) {
        req.message = req.error.debugDescription
        req.state.value = RequestState.Failed
        EZPrintln(req.message)
    }
    
    private class func error (req: EZRequest) {
        req.message = req.output[MSG_KEY] as? String
        req.state.value = RequestState.Error
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
    
    public class var networkReachability: Observable<Reachability.NetworkStatus>? {
        if let d: AnyObject = objc_getAssociatedObject(self, &networkReachabilityHandle) {
            return d as? Observable<Reachability.NetworkStatus>
        } else {
            do {
                let reachability = try Reachability.reachabilityForInternetConnection()
                let d = Observable<Reachability.NetworkStatus>(reachability.currentReachabilityStatus)
                reachability.whenReachable = { reachability in
                    dispatch_async(dispatch_get_main_queue()) {
                        d.value = reachability.currentReachabilityStatus
                    }
                }
                reachability.whenUnreachable = { reachability in
                    dispatch_async(dispatch_get_main_queue()) {
                        d.value = reachability.currentReachabilityStatus
                    }
                }
                try reachability.startNotifier()
                objc_setAssociatedObject(self, &networkReachabilityHandle, d, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return d
            } catch {
                print("Unable to create Reachability")
                return nil
            }
        }
    }
}


