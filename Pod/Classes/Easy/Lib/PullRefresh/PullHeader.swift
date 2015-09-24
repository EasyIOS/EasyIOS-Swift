//
//  PullHeader.swift
//  Demo
//
//  Created by zhuchao on 15/5/16.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import SnapKit
import Bond

public class PullHeader : Header {
    var arrowImage:UIImageView!
    var activityView:UIActivityIndicatorView!
    var statusLabel:UILabel!
    var lastUpdateTimeLabel:UILabel!
    
    init (scrollView:UIScrollView){
        super.init(
            scrollView: scrollView,
            frame: CGRectMake(0, 0, scrollView.size.width, EZPullToRefreshViewHeight))
        self.commonInit()
        
        scrollView.pullToRefreshView!.frame = CGRectMake(0, -EZPullToRefreshViewHeight, scrollView.superview!.size.width, EZPullToRefreshViewHeight)
        
        scrollView.pullToRefreshView!.state.observe{state in
                switch (state){
                case .Stopped:
                    UIView.animateWithDuration(0.25){ [unowned self] in
                        self.resetScrollViewContentInset(scrollView)
                        self.arrowImage.hidden = false
                        self.activityView.stopAnimating()
                        self.statusLabel.text = "下拉可以刷新"
                        self.arrowImage.transform = CGAffineTransformIdentity
                        self.updateTimeLabel(NSDate())
                    }
                case .Pulling:
                    UIView.animateWithDuration(0.25){ [unowned self] in
                        self.arrowImage.hidden = false
                        self.activityView.stopAnimating();
                        self.statusLabel.text = "下拉可以刷新"
                        self.arrowImage.transform = CGAffineTransformIdentity;
                    }
                case .Triggered:
                    UIView.animateWithDuration(0.25){ [unowned self] in
                        self.arrowImage.hidden = false;
                        self.activityView.stopAnimating();
                        self.statusLabel.text = "释放可以刷新"
                        self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
                    }
                case .Loading:
                    UIView.animateWithDuration(0.25){ [unowned self] in
                        self.setScrollViewContentInsetForLoading(scrollView)
                        self.arrowImage.hidden = true;
                        self.activityView.startAnimating();
                        self.statusLabel.text = "正在刷新..."
                    }
                }
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
        
        lastUpdateTimeLabel = UILabel()
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        lastUpdateTimeLabel.font = UIFont.boldSystemFontOfSize(12);
        lastUpdateTimeLabel.textColor = UIColor.blackColor();
        lastUpdateTimeLabel.backgroundColor = UIColor.clearColor();
        lastUpdateTimeLabel.textAlignment = NSTextAlignment.Center;
        self.updateTimeLabel(NSDate())
        self.addSubview(lastUpdateTimeLabel)
        
        arrowImage.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.centerY.equalTo(self.arrowImage.superview!)
        }
        activityView.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.edges.equalTo(self.arrowImage)
        }
        statusLabel.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.top.equalTo(self.statusLabel.superview!).offset(10.0)
            make.centerX.equalTo(self.statusLabel.superview!)
        }
        lastUpdateTimeLabel.snp_makeConstraints(){[unowned self] (make) -> Void in
            make.bottom.equalTo(self.lastUpdateTimeLabel.superview!).offset(-15.0)
            make.centerX.equalTo(self.lastUpdateTimeLabel.superview!)
            make.leading.equalTo(self.arrowImage).offset(40)
        }
    }
    
    func updateTimeLabel(date:NSDate?){
        if let aDate = date {
            // 1.获得年月日
            let calendar = NSCalendar.currentCalendar()
            let unitFlags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute]
            
            let cmp1 = calendar.components(unitFlags, fromDate: aDate)
            let now = calendar.components(unitFlags, fromDate: NSDate())
            
            // 2.格式化日期
            let formatter = NSDateFormatter()
            if (cmp1.day == now.day) { // 今天
                formatter.dateFormat = "今天 HH:mm";
            } else if (cmp1.year == now.year) { // 今年
                formatter.dateFormat = "MM-dd HH:mm";
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm";
            }
            // 3.显示日期
            self.lastUpdateTimeLabel.text = "最后更新：" + formatter.stringFromDate(aDate)
        }
    }
    
    
}