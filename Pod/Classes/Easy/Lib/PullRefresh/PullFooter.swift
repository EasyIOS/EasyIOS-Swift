//
//  PullFooter.swift
//  Demo
//
//  Created by zhuchao on 15/5/16.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

public class PullFooter : Footer {
    var arrowImage:UIImageView!
    var activityView:UIActivityIndicatorView!
    var statusLabel:UILabel!
    
    init (scrollView:UIScrollView){
        super.init(
            scrollView: scrollView,
            frame: CGRectMake(0, 0, scrollView.superview!.size.width, EZInfiniteScrollingViewHeight))
        self.commonInit()
        
        scrollView.infiniteScrollingView!.frame = CGRectMake(0,scrollView.contentSize.height, scrollView.superview!.size.width, EZInfiniteScrollingViewHeight)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        
        
        scrollView.infiniteScrollingView!.state.observe{state in
            switch (state){
            case .Ended:
                self.arrowImage.hidden = true
                self.activityView.stopAnimating()
                self.statusLabel.text = "没有了哦"
            case .Stopped:
                UIView.animateWithDuration(0.25){ [unowned self] in
                    self.resetScrollViewContentInset(scrollView)
                    self.arrowImage.hidden = false
                    self.activityView.stopAnimating()
                    self.statusLabel.text = "上拉加载"
                    self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            case .Pulling:
                UIView.animateWithDuration(0.25){ [unowned self] in
                    self.arrowImage.hidden = false
                    self.activityView.stopAnimating();
                    self.statusLabel.text = "上拉加载"
                    self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            case .Triggered:
                UIView.animateWithDuration(0.25){ [unowned self] in
                    self.arrowImage.hidden = false;
                    self.activityView.stopAnimating();
                    self.statusLabel.text = "释放加载"
                    self.arrowImage.transform = CGAffineTransformIdentity
                }
            case .Loading:
                UIView.animateWithDuration(0.25){ [unowned self] in
                    self.setScrollViewContentInsetForLoading(scrollView)
                    self.arrowImage.hidden = true;
                    self.activityView.startAnimating();
                    self.statusLabel.text = "正在加载..."
                }
            }
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let scrollView = object as! UIScrollView
        if keyPath == "contentSize" && scrollView.contentSize.height > scrollView.bounds.size.height && scrollView.bounds.size.height > 0  {
            scrollView.infiniteScrollingView!.frame = CGRectMake(0, scrollView.contentSize.height, scrollView.superview!.size.width,EZInfiniteScrollingViewHeight)
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit(){
        let bundle = NSBundle(forClass: self.dynamicType)
        let url = bundle.URLForResource("EasyIOS-Swift", withExtension: "bundle")
        let imageBundle = NSBundle(URL: url!)
        if imageBundle?.loaded == false {
            imageBundle?.load()
        }
        let arrow = UIImage(contentsOfFile: imageBundle!.pathForResource("arrow-down@2x", ofType: "png")!)
        
        arrowImage = UIImageView(image: arrow)
        arrowImage.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        self.addSubview(arrowImage)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.autoresizingMask = arrowImage.autoresizingMask;
        activityView.hidden = true
        self.addSubview(activityView)
        
        statusLabel = UILabel()
        statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        statusLabel.font = UIFont.boldSystemFontOfSize(13);
        statusLabel.textColor = UIColor.blackColor();
        statusLabel.backgroundColor = UIColor.clearColor();
        statusLabel.textAlignment = NSTextAlignment.Center;
        self.addSubview(statusLabel)
        
        arrowImage.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.centerY.equalTo(self.arrowImage.superview!)
        }
        activityView.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.edges.equalTo(self.arrowImage)
        }
        statusLabel.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.leading.equalTo(self.arrowImage).offset(30.0)
            make.center.equalTo(self.statusLabel.superview!)
        }
    }

}