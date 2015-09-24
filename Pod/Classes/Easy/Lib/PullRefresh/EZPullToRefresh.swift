//
//  EZPullToRefresh.swift
//  Demo
//
//  Created by zhuchao on 15/5/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

let EZPullToRefreshViewHeight:CGFloat = 60.0

public enum EZPullToRefreshState {
    case Stopped
    case Triggered
    case Loading
    case Pulling
}

public class Header : UIView {
    
    init(scrollView:UIScrollView,frame: CGRect = CGRectZero) {
        super.init(frame: frame)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func resetScrollViewContentInset(scrollView:UIScrollView){
        var currentInsets = scrollView.contentInset
        currentInsets.top = scrollView.pullToRefreshView!.originalTopInset
        self.setScrollViewContentInset(currentInsets, scrollView: scrollView)
    }
    
    public func setScrollViewContentInsetForLoading(scrollView:UIScrollView){
        let offset = max(EZPullToRefreshViewHeight, 0)
        var currentInsets = scrollView.contentInset
        currentInsets.top = max(offset, scrollView.pullToRefreshView!.originalTopInset + scrollView.pullToRefreshView!.bounds.size.height)
        self.setScrollViewContentInset(currentInsets, scrollView: scrollView)
    }
    
    public func setScrollViewContentInset(contentInset:UIEdgeInsets,scrollView:UIScrollView){
        UIView.animateWithDuration(0.3, delay: 0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: {
            scrollView.contentInset = contentInset
        },completion:nil)
    }
}




public class EZPullToRefreshView : UIView {
    
    public var state = Observable<EZPullToRefreshState>(.Stopped)
    public var originalTopInset:CGFloat = 0.0
    public var originalBottomInset:CGFloat = 0.0
    public var originalOffset:CGFloat = 0.0
    private var pullToRefreshActionHandler:(Void -> ())?
    private var oldState = EZPullToRefreshState.Stopped
    
    private func commonInit(){
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.state.observe{ [unowned self] state in
            if state == .Loading && self.oldState == .Triggered {
                self.pullToRefreshActionHandler?()
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
    
    public func startAnimating(){
        self.state.value = .Loading
    }

    public func stopAnimating(){
        self.state.value = .Stopped
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let scrollView = object as! UIScrollView
        if keyPath == "contentOffset" && scrollView.showsPullToRefresh {
            if self.state.value != .Loading{
                let pullNum = scrollView.contentOffset.y + self.originalTopInset
                if !scrollView.dragging && self.state.value == .Triggered {
                    self.state.value = .Loading
                }else if scrollView.dragging && self.state.value == .Pulling && pullNum < -EZPullToRefreshViewHeight {
                    self.state.value = .Triggered
                }else if pullNum <= -1 && pullNum > -EZPullToRefreshViewHeight {
                    self.state.value = .Pulling
                }else if pullNum > -1 {
                    self.state.value = .Stopped
                }
            }
        }
    }
}

private var PullToRefreshViewHandle :UInt8 = 0
extension UIScrollView {
    
    public var pullToRefreshView : EZPullToRefreshView? {
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &PullToRefreshViewHandle) {
                return d as? EZPullToRefreshView
            }else{
                return nil
            }
        }set (value){
            objc_setAssociatedObject(self, &PullToRefreshViewHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var showsPullToRefresh :Bool {
        get{
            return !self.pullToRefreshView!.hidden
        }set(value){
            if value {
                self.addObserver(self.pullToRefreshView!, forKeyPath: "contentOffset", options:NSKeyValueObservingOptions.New, context: nil)
                self.pullToRefreshView?.hidden = false
            }else{
                self.removeObserver(self.pullToRefreshView!, forKeyPath: "contentOffset")
                self.pullToRefreshView?.hidden = true
            }
        }
    }

    public func addPullToRefreshWithActionHandler(customer:UIView? = nil,actionHandler:Void -> ()){
        if self.pullToRefreshView == nil {
            let view = EZPullToRefreshView(frame: CGRectZero)
            view.pullToRefreshActionHandler = actionHandler
            view.originalTopInset = self.contentInset.top;
            view.originalBottomInset = self.contentInset.bottom;
            self.pullToRefreshView = view;
            self.showsPullToRefresh = true;
            self.addSubview(self.pullToRefreshView!)
        }
        if customer == nil {
            self.pullToRefreshView?.setCustomView(PullHeader(scrollView: self))
        }else{
            self.pullToRefreshView?.setCustomView(customer!)
        }
    }
    
    public func triggerPullToRefresh(){
        self.pullToRefreshView?.oldState = .Triggered
        self.pullToRefreshView?.startAnimating()
    }
}