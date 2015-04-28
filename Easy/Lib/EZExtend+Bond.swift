//
//  EZBond.swift
//  medical
//
//  Created by zhuchao on 15/4/27.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Bond

infix operator *->> {}

public func *->> <T>(left: InternalDynamic<T>, right: Bond<T>) {
    left.bindTo(right)
    left.retain(right)
}