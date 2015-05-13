//
//  EZExtend+UIAlertController.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit

// MARK: - UIAlertController

public func alert (title: String,
    message: String,
    cancelAction: ((UIAlertAction!)->Void)? = nil,
    okAction: ((UIAlertAction!)->Void)? = nil) -> UIAlertController {
        let a = UIAlertController (title: title, message: message, preferredStyle: .Alert)
        
        if let ok = okAction {
            a.addAction(UIAlertAction(title: "OK", style: .Default, handler: ok))
            a.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelAction))
        } else {
            a.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: cancelAction))
        }
        
        return a
}