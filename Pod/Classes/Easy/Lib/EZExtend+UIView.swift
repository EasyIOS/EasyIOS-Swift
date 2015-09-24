//
//  EZExtend+UIView.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond
// MARK: - UIView

let UIViewAnimationDuration: NSTimeInterval = 1
let UIViewAnimationSpringDamping: CGFloat = 0.5
let UIViewAnimationSpringVelocity: CGFloat = 0.5
var UIViewGestureUniqueArray:CGFloat = 0.6
extension UIView {
    
//    public var gestureUniqueArray: [String:DisposableType] {
//        get {
//            if let viewGestureUniqueArray: AnyObject = objc_getAssociatedObject(self, &UIViewGestureUniqueArray) {
//                return viewGestureUniqueArray as! Dictionary
//            } else {
//                let mapData = [String:DisposableType]()
//                objc_setAssociatedObject(self, &UIViewGestureUniqueArray, mapData, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                return mapData
//            }
//        }set(value){
////            if let viewGestureUniqueArray: AnyObject = objc_getAssociatedObject(self, &UIViewGestureUniqueArray) {
////                
////            } else {
////                let mapData = [String:DisposableType]()
////                mapData[]
////            }
//        
//        }
//       
//    }
    
    // MARK: Custom Initilizer
    
    convenience init (x: CGFloat,
        y: CGFloat,
        w: CGFloat,
        h: CGFloat) {
            self.init (frame: CGRect (x: x, y: y, width: w, height: h))
    }
    
    // MARK: Frame Extensions
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    
    public var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
     var right: CGFloat {
        get {
            return self.x + self.w
        } set (value) {
            self.x = value - self.w
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
    }
    
    
    public var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: size)
        }
    }
    
    
    public func leftWithOffset (offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    public func rightWithOffset (offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    public func topWithOffset (offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    public func botttomWithOffset (offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
    
    
    // MARK: Transform Extensions
    
    public func setRotationX (x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
        
        self.layer.transform = transform
    }
    
    public func setRotationY (y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
        
        self.layer.transform = transform
    }
    
    public func setRotationZ (z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
        
        self.layer.transform = transform
    }
    
    public func setRotation (x: CGFloat,
        y: CGFloat,
        z: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
            transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
            transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
            
            self.layer.transform = transform
    }
    
    
    public func setScale (x: CGFloat,
        y: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DScale(transform, x, y, 1)
            
            self.layer.transform = transform
    }
    
    
    
    // MARK: Anchor Extensions
    
    public func setAnchorPosition (anchorPosition: AnchorPosition) {
        print(anchorPosition.rawValue)
        self.layer.anchorPoint = anchorPosition.rawValue
    }
    
    
    
    // MARK: Layer Extensions
    
    public func addShadow (offset: CGSize,
        radius: CGFloat,
        color: UIColor,
        opacity: Float) {
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = opacity
            self.layer.shadowColor = color.CGColor
    }
    
    public func addBorder (width: CGFloat,
        color: UIColor) {
            self.layer.borderWidth = width
            self.layer.borderColor = color.CGColor
            self.layer.masksToBounds = true
    }
    
    
    public func setCornerRadius (radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    
    public func drawCircle (fillColor: UIColor,
        strokeColor: UIColor,
        strokeWidth: CGFloat) {
            let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
            
            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = fillColor.CGColor
            shapeLayer.strokeColor = strokeColor.CGColor
            shapeLayer.lineWidth = strokeWidth
            
            self.layer.addSublayer(shapeLayer)
    }
    
    public func drawStroke (width: CGFloat,
        color: UIColor) {
            let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
            
            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.strokeColor = color.CGColor
            shapeLayer.lineWidth = width
            
            self.layer.addSublayer(shapeLayer)
    }
    
    public func drawArc (from: CGFloat,
        to: CGFloat,
        clockwise: Bool,
        width: CGFloat,
        fillColor: UIColor,
        strokeColor: UIColor,
        lineCap: String) {
            let path = UIBezierPath (arcCenter: self.center, radius: self.w/2, startAngle: degreesToRadians(from), endAngle: degreesToRadians(to), clockwise: clockwise)
            
            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = fillColor.CGColor
            shapeLayer.strokeColor = strokeColor.CGColor
            shapeLayer.lineWidth = width
            
            self.layer.addSublayer(shapeLayer)
    }
    
    
    
    // MARK: Animation Extensions
    
    public func spring (animations: (()->Void)!,
        completion: ((Bool)->Void)? = nil) {
            UIView.animateWithDuration(UIViewAnimationDuration,
                delay: 0,
                usingSpringWithDamping: UIViewAnimationSpringDamping,
                initialSpringVelocity: UIViewAnimationSpringVelocity,
                options: UIViewAnimationOptions.AllowAnimatedContent,
                animations: animations,
                completion: completion)
    }
    
    public func animate (animations: (()->Void)!,
        completion: ((Bool)->Void)? = nil) {
            UIView.animateWithDuration(UIViewAnimationDuration,
                animations: animations,
                completion: completion)
    }
    
    
    
    // MARK: Gesture Extensions
    
    public func addTapGesture (tapNumber: NSInteger,
        target: AnyObject, action: Selector) {
            let tap = UITapGestureRecognizer (target: target, action: action)
            tap.numberOfTapsRequired = tapNumber
            self.addGestureRecognizer(tap)
    }
    
    public func addSwipeGesture (direction: UISwipeGestureRecognizerDirection,
        numberOfTouches: Int,
        target: AnyObject,
        action: Selector) {
            let swipe = UISwipeGestureRecognizer (target: target, action: action)
            swipe.direction = direction
            swipe.numberOfTouchesRequired = numberOfTouches
            self.addGestureRecognizer(swipe)
    }
    
    public func addPanGesture (target: AnyObject,
        action: Selector) {
            let pan = UIPanGestureRecognizer (target: target, action: action)
            self.addGestureRecognizer(pan)
    }
    
    public func whenTap(number:NSInteger = 1,block:()->Void) -> DisposableType{
        self.userInteractionEnabled = true
        return bnd_tapGestureEvent(number).observe { (_) -> () in
            block()
        }
    }
    
    public func whenSwipe(number:NSInteger = 1,direction:UISwipeGestureRecognizerDirection,block:()->Void) -> DisposableType{
        self.userInteractionEnabled = true
        return bnd_swipeGestureEvent(number).observe { (_) -> () in
            block()
        }
    }
}
