import UIKit
import JavaScriptCore


public class EZJSDocument{
    
    public var context = EZJSContext()
    
    init(){
    }
    
    public func define(funcName:String,actionBlock:@objc_block ()->Void){
        context.define(funcName, actionBlock: actionBlock)
    }
    
    public func eval(script: String) -> JSValue{
        return context.evaluateScript(script)
    }
}
