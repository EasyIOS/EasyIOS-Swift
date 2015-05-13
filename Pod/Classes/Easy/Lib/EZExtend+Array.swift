//
//  EZExtend+Array.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

extension Array {
    
    func stringAtIndex(index:Int,other:String) -> String{
        if self.count >= index + 1 {
            return (self[index] as! String).trim
        }else{
            return other
        }
    }
    
    func floatAtIndex(index:Int,other:CGFloat) -> CGFloat{
        if self.count >= index + 1 {
            return (self[index] as! String).trim.floatValue
        }else{
            return other
        }
    }
}