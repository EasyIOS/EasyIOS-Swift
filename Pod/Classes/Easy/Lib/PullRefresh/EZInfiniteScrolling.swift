//
//  EZInfiniteScrolling.swift
//  Demo
//
//  Created by zhuchao on 15/5/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

let EZInfiniteScrollingViewHeight:CGFloat = 60.0

public enum EZInfiniteScrollingState {
    case Stopped
    case Triggered
    case Loading
    case Pulling
    case Ended
}

public class Footer:UIView {
    init(scrollView:UIScrollView,frame: CGRect = CGRectZero) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func resetScrollViewContentInset(scrollView:UIScrollView){
        var currentInsets = scrollView.contentInset
        let newBottom = scrollView.infiniteScrollingView!.originalBottomInset + scrollView.infiniteScrollingView!.extendBottom;
        if newBottom != currentInsets.bottom {
            currentInsets.bottom = newBottom
            self.setScrollViewContentInset(currentInsets, scrollView: scrollView)
        }
    }
    
    public func setScrollViewContentInsetForLoading(scrollView:UIScrollView){
        var currentInsets = scrollView.contentInset
        let newBottom  = scrollView.infiniteScrollingView!.originalBottomInset + scrollView.infiniteScrollingView!.extendBottom + EZInfiniteScrollingViewHeight;
        if newBottom != currentInsets.bottom {
            currentInsets.bottom = newBottom
            self.setScrollViewContentInset(currentInsets, scrollView: scrollView)
        }
    }
    
    public func setScrollViewContentInset(contentInset:UIEdgeInsets,scrollView:UIScrollView){
        UIView.animateWithDuration(0.3, delay: 0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: {
                scrollView.contentInset = contentInset
            },completion:nil)
    }
}

public class EZInfiniteScrollingView :UIView {
    public var state = Observable<EZInfiniteScrollingState>(.Stopped)
    public var extendBottom:CGFloat = 0.0
    public var originalBottomInset:CGFloat = 0.0
    private var infiniteScrollingHandler:(Void -> ())?
    private var oldState = EZInfiniteScrollingState.Stopped
    
    private func commonInit(){
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        self.state.observe{ [unowned self] state in
            if state == .Loading && self.oldState == .Triggered {
                self.infiniteScrollingHandler?()
            }
            self.oldState = state
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func setCustomView(customView:UIView){
        if customView.isKindOfClass(UIView) {
            for view in self.subviews {
                view.removeFromSuperview()
            }
            self.addSubview(customView)
            let viewBounds = customView.bounds;
            let origin = CGPointMake(
                CGFloat(roundf(Float(self.bounds.size.width-viewBounds.size.width)/2)),
                CGFloat(roundf(Float(self.bounds.size.height-viewBounds.size.height)/2)))
            customView.frame =  CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)
        }
    }
    
    public func resetState(){
        self.state.value = .Stopped;
    }
    
    public func startAnimating(){
        self.state.value = .Loading;
    }
    
    public func stopAnimating(){
        self.state.value = .Stopped;
    }
    
    public func setEnded(){
        self.state.value = .Ended;
    }
    
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let scrollView = object as! UIScrollView
        if keyPath == "contentOffset" && scrollView.showsInfiniteScrolling {
            if self.state.value != .Loading && self.state.value != .Ended  && scrollView.contentSize.height > 0{
                let scrollViewContentHeight = scrollView.contentSize.height;
                let scrollOffsetThreshold =  scrollViewContentHeight - scrollView.bounds.size.height + self.extendBottom
                
                if !scrollView.dragging && self.state.value == .Triggered {
                    self.state.value = .Loading
                }else if scrollView.dragging && self.state.value == .Pulling && scrollView.contentOffset.y - scrollOffsetThreshold > EZInfiniteScrollingViewHeight {
                    self.state.value = .Triggered
                }else if scrollView.contentOffset.y - scrollOffsetThreshold <= 1 && self.state.value != .Stopped {
                    self.state.value = .Stopped
                }else if scrollView.contentOffset.y - scrollOffsetThreshold > 0 && scrollView.contentOffset.y - scrollOffsetThreshold < EZInfiniteScrollingViewHeight  {
                    self.state.value = .Pulling
                }
            }
        }else if keyPath == "contentSize" && scrollView.contentSize.height >= scrollView.bounds.size.height && scrollView.showsInfiniteScrolling == false  {
                scrollView.showsInfiniteScrolling = true // 当contentSize.height大于scrollView的高度时才显示上拉加载
        }
    }
}

private var InfiniteScrollingViewHandle :UInt8 = 1
extension UIScrollView {
    
    public var infiniteScrollingView : EZInfiniteScrollingView? {
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &InfiniteScrollingViewHandle) {
                return d as? EZInfiniteScrollingView
            }else{
                return nil
            }
        }set (value){
            objc_setAssociatedObject(self, &InfiniteScrollingViewHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var showsInfiniteScrolling :Bool {
        get{
            return !self.infiniteScrollingView!.hidden
        }set(value){
            if value {
                self.addObserver(self.infiniteScrollingView!, forKeyPath: "contentOffset", options:NSKeyValueObservingOptions.New, context: nil)
                self.infiniteScrollingView?.hidden = false
            }else if (self.infiniteScrollingView?.hidden == false){
                self.removeObserver(self.infiniteScrollingView!, forKeyPath: "contentOffset")
                self.infiniteScrollingView?.hidden = true
            }
        }
    }
    
    public func addInfiniteScrollingWithActionHandler(customer:UIView? = nil,actionHandler:Void -> ()){
        if self.infiniteScrollingView == nil {
            let view = EZInfiniteScrollingView(frame: CGRectZero)
            view.infiniteScrollingHandler = actionHandler
            view.originalBottomInset = self.contentInset.bottom
            view.hidden = true
            self.infiniteScrollingView = view;
            
            self.addObserver(self.infiniteScrollingView!, forKeyPath: "contentSize", options:NSKeyValueObservingOptions.New, context: nil)
            
            self.addSubview(self.infiniteScrollingView!)
        }
        
        if customer == nil {
            self.infiniteScrollingView?.setCustomView(PullFooter(scrollView: self))
        }else{
            self.infiniteScrollingView?.setCustomView(customer!)
        }
    }
    
    public func triggerInfiniteScrolling(){
        self.infiniteScrollingView?.oldState = .Triggered
        self.infiniteScrollingView?.startAnimating()
    }
}