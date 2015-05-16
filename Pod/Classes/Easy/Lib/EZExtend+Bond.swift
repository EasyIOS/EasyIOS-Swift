//
//  EZBond.swift
//  medical
//
//  Created by zhuchao on 15/4/27.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Bond

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
            let bond = Bond<NSURL?>() { [weak self] v in if let s = self { s.sd_setImageWithURL(v) } }
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