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
infix operator <-- {}

public func *->> <T>(left: InternalDynamic<T>, right: Bond<T>) {
    left.bindTo(right)
    left.retain(right)
}


@objc class TapGestureDynamicHelper
{
    weak var view: UIView?
    var listener:  (NSInteger -> Void)?
    init(view: UIView) {
        self.view = view
        view.addTapGesture(1, target: self, action: Selector("tapHandle:"))
    }
    
    func tapHandle(view: UIView) {
        self.listener?(1)
    }
}

public class TapGestureDynamic<T>: InternalDynamic<NSInteger>
{
    let helper: TapGestureDynamicHelper
    
    init(view: UIView) {
        self.helper = TapGestureDynamicHelper(view: view)
        super.init()
        self.helper.listener =  { [unowned self] in
            self.value = $0
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
