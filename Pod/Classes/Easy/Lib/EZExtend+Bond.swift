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