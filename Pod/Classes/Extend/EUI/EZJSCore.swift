import UIKit
import JavaScriptCore


@objc protocol ConsoleExport:JSExport {
    static func log(object:AnyObject?)
}

@objc public class Console:NSObject,ConsoleExport {
    static public func log(object:AnyObject?){
        if let obj: AnyObject = object{
            print(obj)
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
        let viewController = UIViewController.initFromString(url, fromConfig: URLManager.shareInstance().config)
        let nav = EZNavigationController(rootViewController: viewController)
        URLNavigation.presentViewController(nav, animated: animated)
    }
    
    static public func push(url:String,_ animated:Bool){
        URLManager.pushURLString(url, animated: animated)
    }
    
    static public func dismiss(animated:Bool){
        URLNavigation.dismissCurrentAnimated(animated)
    }
}

public class EZJSContext:JSContext{
    
    override init(){
        super.init()
        
        self.setObject(Console.self, forKeyedSubscript: "console")
        self.setObject(JSURLManager.self, forKeyedSubscript: "um")
        
        class_addProtocol(EZAction.self, EZActionJSExport.self)
        self.setObject(EZAction.self, forKeyedSubscript: "EZAction")
        
        class_addProtocol(UIColor.self, EUIColor.self)
        self.setObject(UIColor.self, forKeyedSubscript: "UIColor")
        
        class_addProtocol(UIImage.self, EUIImage.self)
        self.setObject(UIImage.self, forKeyedSubscript: "UIImage")
        
        class_addProtocol(UIView.self, EUIView.self)
        self.setObject(UIView.self, forKeyedSubscript: "UIView")
        
        class_addProtocol(UIImageView.self, EUIImageView.self)
        self.setObject(UIImageView.self, forKeyedSubscript: "UIImageView")
        
        class_addProtocol(UITextField.self, EUITextField.self)
        self.setObject(UITextField.self, forKeyedSubscript: "UITextField")

        class_addProtocol(UIButton.self, EUIButton.self)
        self.setObject(UIButton.self, forKeyedSubscript: "UIButton")

        class_addProtocol(UILabel.self, EUILabel.self)
        self.setObject(UILabel.self, forKeyedSubscript: "UILabel")

        class_addProtocol(UIScrollView.self, EUIScrollView.self)
        self.setObject(UIScrollView.self, forKeyedSubscript: "UIScrollView")

        class_addProtocol(UITableView.self, EUITableView.self)
        self.setObject(UITableView.self, forKeyedSubscript: "UITableView")
        
        class_addProtocol(UICollectionView.self, EUICollectionView.self)
        self.setObject(UICollectionView.self, forKeyedSubscript: "UICollectionView")
        
        
        self.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
    }
    
    override init(virtualMachine: JSVirtualMachine!) {
        super.init(virtualMachine:virtualMachine)
    }

    
    public func define(funcName:String,actionBlock:@convention(block) ()->Void){
        self.setObject(unsafeBitCast(actionBlock, AnyObject.self), forKeyedSubscript:funcName)
    }
}
