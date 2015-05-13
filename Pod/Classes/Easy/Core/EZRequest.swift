//
//  Request.swift
//  medical
//
//  Created by zhuchao on 15/4/24.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond
import Alamofire

public enum RequestState : Int {
    case Default  //初始化状态
    case Success 
    case Failed
    case Sending
    case Error
    case Cancle
    case Suspend
    case SuccessFromCache
    case ErrorFromCache
}
private var enabledDynamicHandleRequest: UInt8 = 0;
private var stateDynamicHandleRequest: UInt8 = 1;
public class EZRequest: NSObject {
    public var output = Dictionary<String,AnyObject>() // 序列化后的数据
    public var params = Dictionary<String,AnyObject>() //使用字典参数
    public var responseString:String? // 获取的字符串数据
    public var error:NSError? //请求的错误
    public var state = InternalDynamic<RequestState>(.Default) //Request状态
    public var url:NSURL? //请求的链接
    public var message:String? //错误消息或者服务器返回的MSG
    public var codeKey:Int?  // 错误码返回
    
    //upload上传相关参数
    public var uploadData:NSData?  //上传文件
    public var progress = 0.0 //上传进度
    public var totalBytesWritten = 0.0 //已上传数据大小
    public var totalBytesExpectedToWrite = 0.0  //全部需要上传的数据大小
    
    // download下载相关参数
    public var downloadUrl = ""
    public var targetPath = ""
    public var totalBytesRead = 0.0 //已下载传数据大小
    public var totalBytesExpectedToRead = 0.0 //全部需要下载的数据大小
    
    public var scheme = "http"  //协议
    public var host = ""           //域名
    public var path = ""       //请求路径
    public var staticPath = "" //其他路径
    public var method = Method.GET     //提交方式
    public var parameterEncoding = ParameterEncoding.URL //编码方式 Http头参数设置
    public var needCheckCode = true  //是否需要检查错误码
    
    public var acceptableContentTypes = ["application/json"]  //可接受的序列化返回数据的格式
    public var requestBlock:(Void->())?
    public var isFirstRequest = false
    public var op:Request?
    
    public var requestNeedActive: Dynamic<Bool> {
        if let d: AnyObject = objc_getAssociatedObject(self, &enabledDynamicHandleRequest) {
            return (d as? Dynamic<Bool>)!
        } else {
            let d = InternalDynamic<Bool>(false)
            let bond = Bond<Bool>() { [weak self] v in if let s = self {
                if v {
                    d.value = false
                    s.requestBlock?()
                }
            }}
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &enabledDynamicHandleRequest, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }

    var useCache = false
    var dataFromCache = false

    
    public var requestKey :String {
        return self.nameOfClass
    }
    
    public class var requestKey:String {
        return self.nameOfClass
    }
    
    public var requestParams :Dictionary<String,AnyObject>{
        return self.listProperties()
    }
    
    public var appendPathInfo :String {
        var pathInfo = self.pathInfo
        if pathInfo != nil && !isEmpty(pathInfo!) {
            for (key,nsValue) in self.requestParams {
                var par = "(\\{\(key)\\})"
                var str = "\(nsValue)"
                pathInfo = NSRegularExpression(pattern: par, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)?.stringByReplacingMatchesInString(str, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, count(pathInfo!)), withTemplate: str)
            }
        }
        if pathInfo == nil {
            pathInfo = ""
        }
        return pathInfo!
    }
    
    public var pathInfo :String?{
        return nil
    }
    
    //the key for cache
    public var cacheKey :String{
        if self.method == .GET {
            return self.url!.absoluteString!.MD5
        }else if !isEmpty(self.requestParams) {
            return (self.url!.absoluteString! + self.requestParams.joinPath).MD5
        }else{
            return self.url!.absoluteString!.MD5
        }
    }
    
    public func suspend() {
        self.op?.suspend()
        self.state.value = .Suspend
    }
    
    public func resume() {
        self.op?.resume()
        self.state.value = .Sending
    }
    
    public func cancel() {
        self.op?.cancel()
        self.state.value = .Cancle
    }
    

}






