//
//  EZExtend+UIView.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit


// MARK: - UIView

let UIViewAnimationDuration: NSTimeInterval = 1
let UIViewAnimationSpringDamping: CGFloat = 0.5
let UIViewAnimationSpringVelocity: CGFloat = 0.5

extension UIView {
    
    // MARK: Custom Initilizer
    
    convenience init (x: CGFloat,
        y: CGFloat,
        w: CGFloat,
        h: CGFloat) {
            self.init (frame: CGRect (x: x, y: y, width: w, height: h))
    }
    
    
    
    // MARK: Frame Extensions
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    
    var left: CGFloat {
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
    
    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
    }
    
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: size)
        }
    }
    
    
    func leftWithOffset (offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    func rightWithOffset (offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    func topWithOffset (offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    func botttomWithOffset (offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
    
    
    // MARK: Transform Extensions
    
    func setRotationX (x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
        
        self.layer.transform = transform
    }
    
    func setRotationY (y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
        
        self.layer.transform = transform
    }
    
    func setRotationZ (z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
        
        self.layer.transform = transform
    }
    
    func setRotation (x: CGFloat,
        y: CGFloat,
        z: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
            transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
            transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
            
            self.layer.transform = transform
    }
    
    
    func setScale (x: CGFloat,
        y: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DScale(transform, x, y, 1)
            
            self.layer.transform = transform
    }
    
    
    
    // MARK: Anchor Extensions
    
    func setAnchorPosition (anchorPosition: AnchorPosition) {
        println(anchorPosition.rawValue)
        self.layer.anchorPoint = anchorPosition.rawValue
    }
    
    
    
    // MARK: Layer Extensions
    
    func addShadow (offset: CGSize,
        radius: CGFloat,
        color: UIColor,
        opacity: Float) {
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = opacity
            self.layer.shadowColor = color.CGColor
    }
    
    func addBorder (width: CGFloat,
        color: UIColor) {
            self.layer.borderWidth = width
            self.layer.borderColor = color.CGColor
            self.layer.masksToBounds = true
    }
    
    
    func setCornerRadius (radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    
    func drawCircle (fillColor: UIColor,
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
    
    func drawStroke (width: CGFloat,
        color: UIColor) {
            let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
            
            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.strokeColor = color.CGColor
            shapeLayer.lineWidth = width
            
            self.layer.addSublayer(shapeLayer)
    }
    
    func drawArc (from: CGFloat,
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
    
    func spring (animations: (()->Void)!,
        completion: ((Bool)->Void)? = nil) {
            UIView.animateWithDuration(UIViewAnimationDuration,
                delay: 0,
                usingSpringWithDamping: UIViewAnimationSpringDamping,
                initialSpringVelocity: UIViewAnimationSpringVelocity,
                options: UIViewAnimationOptions.AllowAnimatedContent,
                animations: animations,
                completion: completion)
    }
    
    func animate (animations: (()->Void)!,
        completion: ((Bool)->Void)? = nil) {
            UIView.animateWithDuration(UIViewAnimationDuration,
                animations: animations,
                completion: completion)
    }
    
    
    
    // MARK: Gesture Extensions
    
    func addTapGesture (tapNumber: NSInteger,
        target: AnyObject, action: Selector) {
            let tap = UITapGestureRecognizer (target: target, action: action)
            tap.numberOfTapsRequired = tapNumber
            self.addGestureRecognizer(tap)
    }
    
    func addSwipeGesture (direction: UISwipeGestureRecognizerDirection,
        numberOfTouches: Int,
        target: AnyObject,
        action: Selector) {
            let swipe = UISwipeGestureRecognizer (target: target, action: action)
            swipe.direction = direction
            swipe.numberOfTouchesRequired = numberOfTouches
            self.addGestureRecognizer(swipe)
    }
    
    func addPanGesture (target: AnyObject,
        action: Selector) {
            let pan = UIPanGestureRecognizer (target: target, action: action)
            self.addGestureRecognizer(pan)
    }
}
