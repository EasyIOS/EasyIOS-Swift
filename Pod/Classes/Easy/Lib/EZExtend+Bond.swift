//
//  EZBond.swift
//  medical
//
//  Created by zhuchao on 15/4/27.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Bond
import TTTAttributedLabel

infix operator *->> {}
infix operator **->> {}
infix operator <-- {}

public func *->> <T>(left: InternalDynamic<T>, right: Bond<T>) {
    left.bindTo(right)
    left.retain(right)
}

public func **->> <T>(left: InternalDynamic<T>, right: Bond<T>) {
    left.bindTo(right)
    left.retainedObjects = [right]
}


@objc class TapGestureDynamicHelper
{
    weak var view: UIView?
    var listener:  (NSInteger -> Void)?
    var number:NSInteger = 1
    init(view: UIView,number:NSInteger) {
        self.view = view
        self.number = number
        view.addTapGesture(number, target: self, action: Selector("tapHandle:"))
    }
    
    func tapHandle(view: UIView) {
        self.listener?(self.number)
    }
}

public class TapGestureDynamic<T>: InternalDynamic<NSInteger>
{
    let helper: TapGestureDynamicHelper
    
    public init(view: UIView,number:NSInteger = 1) {
        self.helper = TapGestureDynamicHelper(view: view,number:number)
        super.init()
        self.helper.listener =  { [unowned self] in
            self.value = $0
        }
    }
}

@objc class SwipeGestureDynamicHelper
{
    weak var view: UIView?
    var listener:  ((NSInteger,UISwipeGestureRecognizerDirection) -> Void)?
    var number:NSInteger = 1
    var direction:UISwipeGestureRecognizerDirection
    init(view: UIView,number:NSInteger,direction:UISwipeGestureRecognizerDirection) {
        self.view = view
        self.number = number
        self.direction = direction
        view.addSwipeGesture(direction, numberOfTouches: number, target: self, action: Selector("swipeHandle:"))
    }
    
    func swipeHandle(view: UIView) {
        self.listener?(self.number,self.direction)
    }
}

public class SwipeGestureDynamic<T>: InternalDynamic<NSInteger>
{
    let helper: SwipeGestureDynamicHelper
    public init(view: UIView,number:NSInteger,direction:UISwipeGestureRecognizerDirection) {
        self.helper = SwipeGestureDynamicHelper(view: view,number:number,direction:direction)
        super.init()
        self.helper.listener =  { number,direction in
            self.value = number
        }
    }
}


@objc class PanGestureDynamicHelper
{
    weak var view: UIView?
    var listener:  ((NSInteger,UISwipeGestureRecognizerDirection) -> Void)?
    var number:NSInteger = 1
    var direction:UISwipeGestureRecognizerDirection
    init(view: UIView,number:NSInteger,direction:UISwipeGestureRecognizerDirection) {
        self.view = view
        self.number = number
        self.direction = direction
        view.addSwipeGesture(direction, numberOfTouches: number, target: self, action: Selector("swipeHandle:"))
    }
    
    func swipeHandle(view: UIView) {
        self.listener?(self.number,self.direction)
    }
}

public class PanGestureDynamic<T>: InternalDynamic<NSInteger>
{
    let helper: PanGestureDynamicHelper
    public init(view: UIView,number:NSInteger,direction:UISwipeGestureRecognizerDirection) {
        self.helper = PanGestureDynamicHelper(view: view,number:number,direction:direction)
        super.init()
        self.helper.listener =  { number,direction in
            self.value = number
        }
    }
}



private var urlImageDynamicHandleUIImageView: UInt8 = 0
extension UIImageView {
    public var dynURLImage: Dynamic<NSURL?> {
        if let d: AnyObject = objc_getAssociatedObject(self, &urlImageDynamicHandleUIImageView) {
            return (d as? Dynamic<NSURL?>)!
        } else {
            let d = InternalDynamic<NSURL?>()
            let bond = Bond<NSURL?>() { [weak self] v in if let s = self {
                if v != nil {
                    s.kf_setImageWithURL(v!)
                }
            } }
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &urlImageDynamicHandleUIImageView, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
}

private var textColorDynamicHandleUILabel: UInt8 = 0
extension UILabel {
    public var dynTextColor: Dynamic<UIColor> {
        if let d: AnyObject = objc_getAssociatedObject(self, &textColorDynamicHandleUILabel) {
            return (d as? Dynamic<UIColor>)!
        } else {
            let d = InternalDynamic<UIColor>(self.textColor ?? UIColor.clearColor())
            let bond = Bond<UIColor>() { [weak self] v in if let s = self { s.textColor = v } }
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &textColorDynamicHandleUILabel, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
}

private var textDynamicHandleTTTAttributeLabel: UInt8 = 0
private var attributedTextDynamicHandleTTTAttributeLabel: UInt8 = 0
private var dataDynamicHandleTTTAttributeLabel: UInt8 = 0

extension TTTAttributedLabel: Bondable {
     public var dynTTText: Dynamic<String> {
        if let d: AnyObject = objc_getAssociatedObject(self, &textDynamicHandleTTTAttributeLabel) {
            return (d as? Dynamic<String>)!
        } else {
            let d = InternalDynamic<String>(self.text ?? "")
            let bond = Bond<String>() { [weak self] v in if let s = self {
                s.setText(v)
            } }
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &textDynamicHandleTTTAttributeLabel, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
    
    public var dynTTTData: Dynamic<NSData> {
        if let d: AnyObject = objc_getAssociatedObject(self, &dataDynamicHandleTTTAttributeLabel) {
            return (d as? Dynamic<NSData>)!
        } else {
            let d = InternalDynamic<NSData>()
            let bond = Bond<NSData>() { [weak self] v in if let s = self {
                s.setText(NSAttributedString(fromHTMLData: v, attributes: ["dict":s.tagProperty.style]))
            }}
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &dataDynamicHandleTTTAttributeLabel, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
    
    public var dynTTTAttributedText: Dynamic<NSAttributedString> {
        if let d: AnyObject = objc_getAssociatedObject(self, &attributedTextDynamicHandleTTTAttributeLabel) {
            return (d as? Dynamic<NSAttributedString>)!
        } else {
            let d = InternalDynamic<NSAttributedString>(self.attributedText ?? NSAttributedString(string: ""))
            let bond = Bond<NSAttributedString>() { [weak self] v in if let s = self {
                s.setText(v) } }
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &attributedTextDynamicHandleTTTAttributeLabel, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
    
    public var designatedTTTBond: Bond<String> {
        return self.dynTTText.valueBond
    }
}
