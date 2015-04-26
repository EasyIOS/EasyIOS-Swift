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

enum RequestState : Int {
    case Success
    case Failed
    case Sending
    case Error
    case Cancle
    case Suspend
    
}
 
class EZRequest: NSObject {
    var output = Dictionary<String,AnyObject>() // 序列化后的数据
    var params = Dictionary<String,AnyObject>() //使用字典参数
    var responseString = "" // 获取的字符串数据
    var error:NSError? //请求的错误
    var state:RequestState? //Request状态
    var url:NSURL? //请求的链接
    var message = "" //错误消息或者服务器返回的MSG
    var codeKey = 0  // 错误码返回
    
    //upload上传相关参数
    var uploadData:NSData?  //上传文件
    var progress = 0.0 //上传进度
    var totalBytesWritten = 0.0 //已上传数据大小
    var totalBytesExpectedToWrite = 0.0  //全部需要上传的数据大小
    
    // download下载相关参数
    var downloadUrl = ""
    var targetPath = ""
    var totalBytesRead = 0.0 //已下载传数据大小
    var totalBytesExpectedToRead = 0.0 //全部需要下载的数据大小
    
    var scheme = "http"  //协议
    var host = ""           //域名
    var path = ""       //请求路径
    var staticPath = "" //其他路径
    var method = Method.GET     //提交方式
    var parameterEncoding = ParameterEncoding.URL //编码方式 Http头参数设置
    var needCheckCode = true  //是否需要检查错误码
    
    var acceptableContentTypes = ["application/json"]  //可接受的序列化返回数据的格式
    var requestNeedActive = InternalDynamic<Bool>(false)  //是否启动发送请求(为MVVM设计)
    var requestInActiveBlock:Void->()
    var isFirstRequest = false
    var op:Request?
    
    init(block:Void->()) {
        self.requestInActiveBlock = block
        super.init()
        self.loadRequest()
    }
    
    func loadRequest (){
        let myBond = Bond<Bool>() {  [unowned self] value in
            self.requestNeedActive.value = false
            self.requestInActiveBlock()
        }
        self.requestNeedActive.filter{$0 == true} ->> myBond
        self.requestNeedActive.retain(myBond)
        
    }
    
    var useCache = false
    var dataFromCache = false
    
    var succeed: Bool {
        return !isEmpty(self.output) && RequestState.Success == self.state
    }
    
    var failed : Bool {
        return !isEmpty(self.output) && (RequestState.Failed == self.state || RequestState.Error == self.state)
    }
    
    var sending : Bool {
        return RequestState.Sending == self.state
    }
    
    var cancled : Bool {
        return RequestState.Cancle == self.state
    }
    
    var requestKey :String {
        return self.nameOfClass
    }
    
    class var requestKey:String {
        return self.nameOfClass
    }
    
    var requestParams :Dictionary<String,AnyObject>{
        return self.listProperties()
    }
    
    var appendPathInfo :String {
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
    
    var pathInfo :String?{
        return nil
    }
    
    //the key for cache
    var cacheKey :String{
        if self.method == .GET {
            return self.url!.absoluteString!.MD5
        }else if !isEmpty(self.requestParams) {
            return (self.url!.absoluteString! + self.requestParams.joinPath).MD5
        }else{
            return self.url!.absoluteString!.MD5
        }
    }
    
    func suspend() {
        self.op?.suspend()
        self.state = .Suspend
    }
    
    func resume() {
        self.op?.resume()
        self.state = .Sending
    }
    
    func cancel() {
        self.op?.cancel()
        self.state = .Cancle
    }
    
}


