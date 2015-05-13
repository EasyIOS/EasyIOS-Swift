//
//  EZExtend+UIImage.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
// MARK: - UIImage

extension UIImage {
    
    public func aspectResizeWithWidth (width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))
        
        UIGraphicsBeginImageContext(aspectSize)
        self.drawInRect(CGRect(origin: CGPointZero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    public func aspectResizeWithHeight (height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)
        
        UIGraphicsBeginImageContext(aspectSize)
        self.drawInRect(CGRect(origin: CGPointZero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    public func aspectHeightForWidth (width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    public func aspectWidthForHeight (height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
}
