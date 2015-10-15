//
//  EUI.swift
//  medical
//
//  Created by zhuchao on 15/5/5.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

public class EUI: NSObject {
    public class func encode(fileName:String,suffix:String = "xml",toPath:String){
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: suffix)!
        if  NSFileManager.defaultManager().fileExistsAtPath(path) == false{
            return
        }
        if let str = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
            if let encrypt = DesEncrypt.encryptWithText(str, key: CRTPTO_KEY) {
                var error:NSError?
                do {
                    try encrypt.writeToFile(toPath, atomically: true, encoding: NSUTF8StringEncoding)
                    EZPrintln("success")
                } catch let error1 as NSError {
                    error = error1
                    EZPrintln(error)
                }
            }
        }
    }
    
    public class func setLiveLoad(controller:EUScene,suffix:String){
        if IsSimulator && suffix == "xml"{
            let paths = self.loadLiveFile(controller,suffix:suffix)
            if paths?.count > 0 {
                for path in paths! {
                    watchForChangesToFilePath(path) {
                        self.loadLiveFile(controller,suffix:suffix)
                        controller.eu_viewWillLoad()
                        controller.loadEZLayout()
                    }
                }
            }
        }else{
            self.loadHtml(controller, suffix: suffix)
        }
        controller.eu_viewWillLoad()
    }
    
    private class func loadLiveFile(controller:EUScene,suffix:String) -> [String]?{
        let fileName = controller.nameOfClass
        
        let path = NSBundle(path: LIVE_LOAD_PATH)!.pathForResource(fileName, ofType: suffix)!
        if  NSFileManager.defaultManager().fileExistsAtPath(path) == false{
            return nil
        }
        var paths = Array<String>()
        paths.append(path)
        
        do{
            if let html = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding){
                var finalHtml = html
                if let newHtml = Regex("@import\\(([^\\)]*)\\)").replace(finalHtml,withBlock: { (regx) -> String in
                    let subFile = regx.subgroupMatchAtIndex(0)?.trim
                    let subPath = NSBundle(path: LIVE_LOAD_PATH)!.pathForResource(subFile, ofType: suffix)!
                    if NSFileManager.defaultManager().fileExistsAtPath(subPath) {
                        paths.append(subPath)
                        return try! String(contentsOfFile:subPath, encoding: NSUTF8StringEncoding)
                    }else{
                        return ""
                    }
                }) {
                    finalHtml = newHtml
                }
                
                if let regMatchs = Regex("<style>([\\s\\S]*?)</style>").match(finalHtml) {
                    for regx in regMatchs {
                        if let styleString = regx.subgroupMatchAtIndex(0)?.trim,
                            let regxsubs = Regex("\\.([\\w]*)[\\s]*\\{[\\s]?([^}]*)[\\s]?\\}").match(styleString){
                                for regxsub in regxsubs {
                                    let className = regxsub.subgroupMatchAtIndex(0)!.trim
                                    let values = regxsub.subgroupMatchAtIndex(1)!.trim
                                    if let aHtml = Regex("@"+className).replace(finalHtml, withTemplate: values) {
                                        finalHtml = aHtml
                                    }
                                }
                        }
                    }
                }
                
                if let regMatchs = Regex("<script\\b[^>]*>([\\s\\S]*?)</script>").match(finalHtml) {
                    var scriptStrings = "";
                    for regx in regMatchs {
                        if let scriptString = regx.subgroupMatchAtIndex(0)?.trim{
                            scriptStrings += scriptString
                        }
                    }
                    controller.scriptString = scriptStrings
                }
                
                if let cleanHtml = Regex("@[\\w]*").replace(finalHtml, withTemplate: "") {
                    finalHtml = cleanHtml
                }
              
                SwiftTryCatch.`try`({
                    let body = EUIParse.ParseHtml(finalHtml)
                    var views = [UIView]()
                    for aview in body {
                        views.append(aview.getView())
                    }
                    controller.eu_subViews = views
                    }, `catch`: { (error) in
                        print(controller.nameOfClass + "Error:\(error.description)")
                    }, finally: nil)
             
            }else{
                throw NSError(domain: "EasyIOS", code: -1, userInfo: ["err":"can not open "+path.URLString])
            }
        }catch let error as NSError{
            print("error is \(error)")
        }
        
        return paths
    }
    
    private class func loadHtml (controller:EUScene,suffix:String){
        let fileName = controller.nameOfClass
        
        let path = NSBundle(path: BUNDLE_PATH)!.pathForResource(fileName, ofType: suffix)!
        if  NSFileManager.defaultManager().fileExistsAtPath(path) == false{
            return
        }
        if let html = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
            var finalHtml = html
            if suffix == "crypto" && CRTPTO_KEY != "" {
                if let aHtml = DesEncrypt.decryptWithText(finalHtml, key: CRTPTO_KEY) {
                    finalHtml = aHtml
                }
            }
            if let newHtml = Regex("@import\\(([^\\)]*)\\)").replace(finalHtml,withBlock: { (regx) -> String in
                let subFile = regx.subgroupMatchAtIndex(0)?.trim
                let subPath = NSBundle(path: BUNDLE_PATH)!.pathForResource(subFile, ofType: suffix)!
                
                if NSFileManager.defaultManager().fileExistsAtPath(subPath) {
                    return try! String(contentsOfFile:subPath, encoding: NSUTF8StringEncoding)
                }else{
                    return ""
                }
            }) {
                finalHtml = newHtml
            }
            
            
            if let regMatchs = Regex("<style>([\\s\\S]*?)</style>").match(finalHtml) {
                for regx in regMatchs {
                    if let styleString = regx.subgroupMatchAtIndex(0)?.trim,
                        let regxsubs = Regex("\\.([\\w]*)[\\s]*\\{[\\s]?([^}]*)[\\s]?\\}").match(styleString){
                            for regxsub in regxsubs {
                                let className = regxsub.subgroupMatchAtIndex(0)!.trim
                                let values = regxsub.subgroupMatchAtIndex(1)!.trim
                                if let aHtml = Regex("@"+className).replace(finalHtml, withTemplate: values) {
                                    finalHtml = aHtml
                                }
                            }
                    }
                }
            }
            
            if let regMatchs = Regex("<script\\b[^>]*>([\\s\\S]*?)</script>").match(finalHtml) {
                var scriptStrings = "";
                for regx in regMatchs {
                    if let scriptString = regx.subgroupMatchAtIndex(0)?.trim{
                        scriptStrings += scriptString
                    }
                }
                controller.scriptString = scriptStrings
            }
        
            
            if let cleanHtml = Regex("@[\\w]*").replace(finalHtml, withTemplate: "") {
                finalHtml = cleanHtml
            }
            
            SwiftTryCatch.`try`({
                    let body = EUIParse.ParseHtml(finalHtml)
                    var views = [UIView]()
                    for aview in body {
                        views.append(aview.getView())
                    }
                    controller.eu_subViews = views
                }, `catch`: { (error) in
                    print(controller.nameOfClass + "Error:\(error.description)")
                }, finally: nil)
        }
    }
    
    
}
