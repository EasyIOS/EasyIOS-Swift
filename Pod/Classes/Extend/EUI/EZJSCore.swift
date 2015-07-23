import UIKit
import JavaScriptCore


@objc protocol ConsoleExport:JSExport {
    static func log(object:AnyObject?)
}

@objc public class Console:NSObject,ConsoleExport {
    static public func log(object:AnyObject?){
        if let obj: AnyObject = object{
            println(obj)
        }
    }
}


@objc protocol JSURLManagerExport:JSExport {
    static func present(url:String,_ animated:Bool)
    static func push(url:String,_ animated:Bool)
    static func dismiss(animated:Bool)
}

public class JSURLManager:NSObject,JSURLManagerExport {
    static public func present(url:String,_ animated:Bool){
        var viewController = UIViewController.initFromString(url, fromConfig: URLManager.shareInstance().config)
        var nav = EZNavigationController(rootViewController: viewController)
        URLNavigation.presentViewController(nav, animated: animated)
    }
    
    static public func push(url:String,_ animated:Bool){
        URLManager.pushURLString(url, animated: animated)
    }
    
    static public func dismiss(animated:Bool){
        URLNavigation.dismissCurrentAnimated(animated)
    }
}


@objc protocol JSDocummentExport:JSExport {
    static func getElementById(id:String) -> UIView
}

public class Documment:NSObject,JSDocummentExport{
    static public func getElementById(id:String) -> UIView {
        return UIView.formTag(id)
    }
}

public class EZJSContext:JSContext{
    
    override init(){
        super.init()
        
        self.setObject(Console.self, forKeyedSubscript: "console")
        self.setObject(JSURLManager.self, forKeyedSubscript: "um")
        self.setObject(Documment.self, forKeyedSubscript: "document")
        
        
        
        
        class_addProtocol(EZAction.self, EZActionJSExport.self)
        self.setObject(EZAction.self, forKeyedSubscript: "EZAction")
        
        
        class_addProtocol(UIColor.self, EUIColor.self)
        self.setObject(UIColor.self, forKeyedSubscript: "UIColor")
        
        class_addProtocol(UIView.self, EUIView.self)
        self.setObject(UIView.self, forKeyedSubscript: "UIView")
        
        class_addProtocol(UIImageView.self, EUIImageView.self)
        self.setObject(UIImageView.self, forKeyedSubscript: "UIImageView")
        
        class_addProtocol(UITextField.self, EUITextField.self)
        self.setObject(UITextField.self, forKeyedSubscript: "UITextField")

        class_addProtocol(UIButton.self, EUIButton.self)
        self.setObject(UIButton.self, forKeyedSubscript: "UIButton")

        
        
        self.exceptionHandler = { context, exception in
            println("JS Error: \(exception)")
        }
    }
    
    override init(virtualMachine: JSVirtualMachine!) {
        super.init(virtualMachine:virtualMachine)
    }

    
    public func define(funcName:String,actionBlock:@objc_block ()->Void){
        self.setObject(unsafeBitCast(actionBlock, AnyObject.self), forKeyedSubscript:funcName)
    }
}
