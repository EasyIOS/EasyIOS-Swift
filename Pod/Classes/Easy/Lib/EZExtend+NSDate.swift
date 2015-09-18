//
//  EZExtend+NSDate.swift
//  medical
//
//  Created by zhuchao on 15/5/9.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

extension NSDate {
    //format :yyyy-MM-dd
    public func formatTo(format:String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let currentDateStr = dateFormatter.stringFromDate(self)
        return currentDateStr
    }
}
