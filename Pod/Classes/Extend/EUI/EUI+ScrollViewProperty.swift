//
//  EUI+ScrollViewProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/2.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

class ScrollViewProperty:ViewProperty{
    var contentInset = UIEdgeInsetsZero
    var contentOffset = CGPointZero
    var contentSize = CGSizeZero
    var scrollIndicatorInsets = UIEdgeInsetsZero
    var indicatorStyle:UIScrollViewIndicatorStyle = .Default
    var pullToRefresh:PullRefreshAction?
    var infiniteScrolling:InfiniteScrollingAction?
    
    override func view() -> UIScrollView{
        let view = UIScrollView()
        view.tagProperty = self

        self.renderViewStyle(view)
        for subTag in self.subTags {
            view.addSubview(subTag.getView())
        }
        return view
    }
    

    override func renderViewStyle(view: UIView) {
        super.renderViewStyle(view)
        let sview = view as! UIScrollView
        sview.contentInset = self.contentInset
        sview.contentOffset =  self.contentOffset
        sview.contentSize = self.contentSize
        sview.scrollIndicatorInsets = self.scrollIndicatorInsets
        sview.indicatorStyle = self.indicatorStyle
    }
    
    override func renderTag(pelement:OGElement){
        self.tagOut += ["content-offset","content-inset","content-size","scroll-indicator-insets","indicator-style","pull-to-refresh","infinite-scrolling"]
        
        super.renderTag(pelement)
        if let contentInset = EUIParse.string(pelement,key:"content-inset") {
            self.contentInset = UIEdgeInsetsFromString(contentInset)
        }
        if let contentOffset = EUIParse.string(pelement,key:"content-offset") {
            self.contentOffset = CGPointFromString(contentOffset)
        }
        
        if let contentSize = EUIParse.string(pelement,key:"content-size") {
            self.contentSize = CGSizeFromString(contentSize)
        }
        
        if let indicatorStyle = EUIParse.string(pelement,key:"indicator-style") {
            self.indicatorStyle = indicatorStyle.scrollViewIndicatorStyle
        }
        
        if let scrollIndicatorInsets = EUIParse.string(pelement,key:"scroll-indicator-insets") {
            self.scrollIndicatorInsets = UIEdgeInsetsFromString(scrollIndicatorInsets)
        }
        
        if let thePullRefresh = EUIParse.string(pelement, key: "pull-to-refresh") {
            var values = thePullRefresh.trimArray
            if values.count == 1 {
                self.pullToRefresh = PullRefreshAction(selector: values[0])
            }else if values.count == 2 {
                self.pullToRefresh = PullRefreshAction(selector: values[0], viewClass: values[1])
            }
        }
        
        if let theInfiniteScrolling = EUIParse.string(pelement, key: "infinite-scrolling") {
            var values = theInfiniteScrolling.trimArray
            if values.count == 1 {
                self.infiniteScrolling = InfiniteScrollingAction(selector: values[0])
            }else if values.count == 2 {
                self.infiniteScrolling = InfiniteScrollingAction(selector: values[0], viewClass: values[1])
            }
        }
        
    }

}