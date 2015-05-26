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
        var path = NSBundle.mainBundle().pathForResource(fileName, ofType: suffix)!
        if  NSFileManager.defaultManager().fileExistsAtPath(path) == false{
            return
        }
        if let str = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
            if let encrypt = DesEncrypt.encryptWithText(str, key: CRTPTO_KEY) {
                var error:NSError?
                if encrypt.writeToFile(toPath, atomically: true, encoding: NSUTF8StringEncoding, error: &error) {
                    EZPrintln("success")
                }else{
                    EZPrintln(error)
                }
            }
        }
    }
    
    public class func setLiveLoad(filePath:String,controller:EUScene,suffix:String){
        if IsSimulator && suffix == "xml"{
            var paths = self.loadLiveFile(filePath, controller: controller,suffix:suffix)
            if paths?.count > 0 {
                for path in paths! {
                    watchForChangesToFilePath(path) {
                        self.loadLiveFile(filePath, controller: controller,suffix:suffix)
                    }
                }
            }
        }else{
            self.loadHtml(controller, suffix: suffix)
        }
    }
    
    private class func loadLiveFile(filePath:String,controller:EUScene,suffix:String) -> [String]?{
        var fileName = controller.nameOfClass
        
        var path = filePath.stringByAppendingPathComponent(fileName+"."+suffix)
        if  NSFileManager.defaultManager().fileExistsAtPath(path) == false{
            return nil
        }
        var paths = Array<String>()
        paths.append(path)
        if let html = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
            
            var finalHtml = html
            if let newHtml = Regex("@import\\(([^\\)]*)\\)").replace(finalHtml,withBlock: { (regx) -> String in
                var subFile = regx.subgroupMatchAtIndex(0)?.trim
                var subPath = NSBundle.mainBundle().pathForResource(subFile, ofType: suffix)!
                if NSFileManager.defaultManager().fileExistsAtPath(subPath) {
                    paths.append(subPath)
                    return String(contentsOfFile:subPath, encoding: NSUTF8StringEncoding, error: nil)!
                }else{
                    return ""
                }
            }) {
                finalHtml = newHtml
            }
            Regex("\\.([\\w]*)[\\s]?\\{[\\s]?([^}]*)[\\s]?\\}").replace(finalHtml) { (regx) -> String in
                var className = regx.subgroupMatchAtIndex(0)!.trim
                var values = regx.subgroupMatchAtIndex(1)!.trim
                if let aHtml = Regex("@"+className).replace(finalHtml, withTemplate: values) {
                    finalHtml = aHtml
                }
                return ""
            }
            if let cleanHtml = Regex("@[\\w]*").replace(finalHtml, withTemplate: "") {
                finalHtml = cleanHtml
            }
            controller.loadEZLayout(finalHtml)
        }
        return paths
    }
    
    
    
    private class func loadHtml (controller:EUScene,suffix:String){
        var fileName = controller.nameOfClass
        
        var path = NSBundle.mainBundle().pathForResource(fileName, ofType: suffix)!
        if  NSFileManager.defaultManager().fileExistsAtPath(path) == false{
            return
        }
        if let html = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
            var finalHtml = html
            if suffix == "crypto" && CRTPTO_KEY != "" {
                if let aHtml = DesEncrypt.decryptWithText(finalHtml, key: CRTPTO_KEY) {
                    finalHtml = aHtml
                }
            }
            if let newHtml = Regex("@import\\(([^\\)]*)\\)").replace(finalHtml,withBlock: { (regx) -> String in
                var subFile = regx.subgroupMatchAtIndex(0)?.trim
                var subPath = NSBundle.mainBundle().pathForResource(subFile, ofType: suffix)!
                
                if NSFileManager.defaultManager().fileExistsAtPath(subPath) {
                    return String(contentsOfFile:subPath, encoding: NSUTF8StringEncoding, error: nil)!
                }else{
                    return ""
                }
            }) {
                finalHtml = newHtml
            }
            Regex("\\.([\\w]*)[\\s]?\\{[\\s]?([^}]*)[\\s]?\\}").replace(finalHtml) { (regx) -> String in
                var className = regx.subgroupMatchAtIndex(0)!.trim
                var values = regx.subgroupMatchAtIndex(1)!.trim
                if let aHtml = Regex("@"+className).replace(finalHtml, withTemplate: values) {
                    finalHtml = aHtml
                }
                return ""
            }
            if let cleanHtml = Regex("@[\\w]*").replace(finalHtml, withTemplate: "") {
                finalHtml = cleanHtml
            }
            controller.loadEZLayout(finalHtml)
        }
    }
    
    
}
