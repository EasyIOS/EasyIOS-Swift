//
//  EUIExtend+UIView.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import SnapKit
import Bond
import Kingfisher
import TTTAttributedLabel

private var UIViewTagIdHandle :UInt8 = 1
private var UIViewViewPropertyHandle :UInt8 = 2
private var UIViewConstraintGroupHandle :UInt8 = 3
private var UIViewWatchHandle :UInt8 = 4
private var TableViewDataSourceBond :UInt8 = 5
private var CollectionViewDataSourceBond :UInt8 = 6
private var attributedLabelDelegateHandle :UInt8 = 7


public class TTTAttributedLabelDelegateHandle:NSObject,TTTAttributedLabelDelegate{
    
}
extension EUScene{
     public var attributedLabelDelegate:TTTAttributedLabelDelegateHandle? {
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &attributedLabelDelegateHandle) {
                return d as? TTTAttributedLabelDelegateHandle
            }else{
                return nil
            }
        }set (value){
            objc_setAssociatedObject(self, &attributedLabelDelegateHandle, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

    func loadEZLayout(html:String){
        self.eu_viewWillLoad()
        SwiftTryCatch.try({ [unowned self] in
            var body = EUIParse.ParseHtml(html)
            var views = [UIView]()
            for aview in body {
                views.append(aview.getView())
            }
            self.view.clearEZView()
            for view in views {
                self.view.addSubview(view)
            }
            self.view.subRender(self)
           
            }, catch: { (error) in
                println(self.nameOfClass + "Error:\(error.description)")
            }, finally: nil)
    }
    
    public var eu_tableViewDataSource: UITableViewDataSourceBond<UITableViewCell>? {
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &TableViewDataSourceBond){
                return d as? UITableViewDataSourceBond<UITableViewCell>
            }else{
                return nil
            }
        }set (value){
            objc_setAssociatedObject(self, &TableViewDataSourceBond, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    public var eu_collectionViewDataSource: UICollectionViewDataSourceBond<UICollectionViewCell>? {
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &CollectionViewDataSourceBond){
                return d as? UICollectionViewDataSourceBond<UICollectionViewCell>
            }else{
                return nil
            }
        }set (value){
            objc_setAssociatedObject(self, &CollectionViewDataSourceBond, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
}

extension UIView {
    
    func clearEZView(){
        for view in self.subviews {
            var aview = view as! UIView
            aview.clearEZView()
            aview.removeFromSuperview()
        }
    }
    
    var tagProperty:ViewProperty{
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &UIViewViewPropertyHandle) {
                return d as! ViewProperty
            }else{
                return ViewProperty()
            }
        }set (value){
            objc_setAssociatedObject(self, &UIViewViewPropertyHandle, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

    public func getSubViewByTagId(tagId:String) -> UIView?{
        for view in self.subviews {
            if view.subviews.count > 0 {
                if let aview = view.getSubViewByTagId(tagId){
                    return aview
                }
            }
            if view.tagProperty.tagId == tagId {
                return view as? UIView
            }
        }
        return nil
    }
    
    public func getRootView() -> UIView {
        if self.superview == nil {
            return self
        }else{
            return self.superview!.getRootView()
        }
    }
    
    func getViewById(tagId:String) -> UIView? {
        if tagId == ""{
            return nil
        }else if tagId == Constrain.targetRoot {
            return self.getRootView()
        }else if tagId == Constrain.targetSuper {
            return self.superview
        }else if tagId == Constrain.targetSelf || tagId == self.tagProperty.tagId{
            return self
        }else{
            return self.getRootView().getSubViewByTagId(tagId)
        }
    }
    
    
    func subRender(scene:EUScene) {
        for subView in self.subviews {
            var view = subView as! UIView
            view.renderTheView(scene)
        }
    }
    
    func renderTheView(scene:EUScene){
        self.subRender(scene)
        self.renderSelector(scene)
        self.renderGesture(scene)
        self.renderLayout()
    }
    
    public func renderDataBinding(bind:EZViewModel?){
        for subView in self.subviews {
            var view = subView as! UIView
            view.renderDataBinding(bind)
        }
        
        if let bindKey = self.tagProperty.bind["background-color"] {
            if let color = bind!.valueForKey(bindKey) as? EZColor {
                color.dym! ->> self.dynBackgroundColor
            }
        }
        if let bindKey = self.tagProperty.bind["alpha"] {
            if let alpha = bind!.valueForKey(bindKey) as? EZFloat {
                alpha.dym! ->> self.dynAlpha
            }
        }
        if let bindKey = self.tagProperty.bind["hidden"] {
            if let hidden = bind!.valueForKey(bindKey) as? EZBool {
                hidden.dym! ->> self.dynHidden
            }
        }
    }

    
    func renderGesture(scene:EUScene){
        var property =  self.tagProperty as ViewProperty
        
        if let push = property.pushUrl {
            TapGestureDynamic<NSInteger>(view: self) *->> Bond<NSInteger>{ value in
                URLManager.pushURLString(push, animated: true)
            }
        }
        
        if let present = property.presentUrl {
            TapGestureDynamic<NSInteger>(view: self) *->> Bond<NSInteger>{ value in
                var viewController = UIViewController.initFromString(present, fromConfig: URLManager.shareInstance().config)
                var nav = EZNavigationController(rootViewController: viewController)
                URLNavigation.presentViewController(nav, animated: true)
            }
        }
        
        if let selector = property.onTap {
            var target:AnyObject!
            if !isEmpty(selector.target){
                target = scene.valueForKeyPath(selector.target)
            }else {
                target = scene
            }
            self.addTapGesture(selector.tapNumber, target: target, action: selector.selector)
        }
        
        if let selector = property.onSwipe {
            var target:AnyObject!
            if !isEmpty(selector.target){
                target = scene.valueForKeyPath(selector.target)
            }else {
                target = scene
            }
            self.addSwipeGesture(selector.direction, numberOfTouches: selector.numberOfTouches, target: target, action: selector.selector)
        }
        
        if let selector = property.onPan {
            var target:AnyObject!
            if !isEmpty(selector.target){
                target = scene.valueForKeyPath(selector.target)
            }else {
                target = scene
            }
            self.addPanGesture(target, action: selector.selector)
        }
        
    }
    
    func renderSelector(scene:EUScene){
      
    }
    
    
    func renderLayout(){
        var consList = self.tagProperty.align + self.tagProperty.margin
        
        if let width = self.tagProperty.width {
            consList.append(width)
        }
        
        if let height = self.tagProperty.height {
            consList.append(height)
        }
        
        if consList.count == 0 {
            return
        }
        self.snp_remakeConstraints(){[unowned self] (make) -> Void in
            for cons  in consList {
                var targetView = self.getViewById(cons.target)
                var value = cons.value
                var key = cons.constrainName
                if targetView != nil {
                    switch key {
                    case .AlignRight:
                        make.right.equalTo(targetView!).offset(value)
                    case .AlignLeft:
                        make.left.equalTo(targetView!).offset(value)
                    case .AlignTop:
                        make.top.equalTo(targetView!).offset(value)
                    case .AlignBottom:
                        make.bottom.equalTo(targetView!).offset(value)
                    case .AlignCenterX:
                        make.centerX.equalTo(targetView!).offset(value)
                    case .AlignCenterY:
                        make.centerY.equalTo(targetView!).offset(value)
                    case .MarginTop:
                        make.top.equalTo(targetView!.snp_bottom).offset(value)
                    case .MarginLeft:
                        make.left.equalTo(targetView!.snp_right).offset(value)
                    case .MarginRight:
                        make.right.equalTo(targetView!.snp_left).offset(-value)
                    case .MarginBottom:
                        make.bottom.equalTo(targetView!.snp_top).offset(-value)
                    case .Width:
                        make.width.equalTo(targetView!.snp_width).multipliedBy(value)
                    case .Height:
                        make.height.equalTo(targetView!.snp_height).multipliedBy(value)
                    default:
                        EZPrintln("remake default")
                    }
                }else {
                    switch key {
                    case .Width:
                        make.width.equalTo(Int(value))
                    case .Height:
                        make.height.equalTo(Int(value))
                    default:
                        EZPrintln("remake default")
                    }
                }
            }
        }
    }
}

extension UIImageView {
    override public func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["src"] {
            if let image = bind!.valueForKey(bindKey) as? EZImage {
                image.dym! ->> self.dynImage
            }else if let src = bind!.valueForKey(bindKey) as? EZURL {
                src.dym! ->> self.dynURLImage
            }else if let image = bind!.valueForKey(bindKey) as? UIImage {
                self.image = image
            }else if let url = bind!.valueForKey(bindKey) as? NSURL {
                self.kf_setImageWithURL(url)
            }else if let str = bind!.valueForKey(bindKey) as? String {
                if let url = NSURL(string: str) {
                    self.kf_setImageWithURL(url)
                }else if let image = UIImage(named: str) {
                    self.image = image
                }
            }
        }else if let bindKey = self.tagProperty.bind["image"] {
            if let image = bind!.valueForKey(bindKey) as? EZImage {
                image.dym! ->> self.dynImage
            }else if let image = bind!.valueForKey(bindKey) as? UIImage {
                self.image = image
            }
        }
    }
}

extension UILabel {
    override public func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["text"] {
            if let text = bind!.valueForKey(bindKey) as? EZAttributedString {
                text.dym! ->> self.dynAttributedText
            }else if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym! ->> self.dynText
            }else if let text = bind!.valueForKey(bindKey) as? String {
                self.text = text
            }else if let data = bind!.valueForKey(bindKey) as? NSData {
                self.attributedText = NSAttributedString(fromHTMLData: data, attributes: ["dict":self.tagProperty.style])
            }else if let string = bind!.valueForKey(bindKey) as? NSAttributedString {
                self.attributedText = string
            }
        }
        if let bindKey = self.tagProperty.bind["text-color"] {
            if let color = bind!.valueForKey(bindKey) as? EZColor {
                color.dym! ->> self.dynTextColor
            }else if let color = bind!.valueForKey(bindKey) as? UIColor {
                self.textColor = color
            }
        }
    }
}

extension TTTAttributedLabel {
    override public func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["TTText"] {
            if let text = bind!.valueForKey(bindKey) as? EZAttributedString {
                text.dym! ->> self.dynTTTAttributedText
            }else if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym! ->> self.dynTTText
            }else if let data = bind!.valueForKey(bindKey) as? EZData {
                data.dym! ->> self.dynTTTData
            }else if let text = bind!.valueForKey(bindKey) as? String {
                self.setText(text)
            }else if let data = bind!.valueForKey(bindKey) as? NSData {
                self.setText(NSAttributedString(fromHTMLData: data, attributes: ["dict":self.tagProperty.style]))
            }else if let string = bind!.valueForKey(bindKey) as? NSAttributedString {
                self.setText(string)
            }
        }
    }
    
    override func renderSelector(scene:EUScene){
        if let delegate = scene.attributedLabelDelegate {
            self.delegate = scene.attributedLabelDelegate
        }
    }
}

extension UITextField {
    override public func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["text"] {
            if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym! ->> self.dynText
            }else if let text = bind!.valueForKey(bindKey) as? String {
                self.text = text
            }
        }
    }
}

extension UIButton {
    override func renderSelector(scene:EUScene){
        var property =  self.tagProperty as? ButtonProperty
        
        if let selector = property?.onEvent {
            var target:AnyObject!
            if !isEmpty(selector.target){
                target = scene.valueForKeyPath(selector.target)
            }else {
                target = scene
            }
            self.addTarget(target, action: selector.selector, forControlEvents: selector.event)
        }
    }
}

private var UITableViewCellHandle :UInt8 = 5
extension UITableView {
    
    public func getSectionViewByTagId(tagId:String,target:EUScene,bind:EZViewModel? = nil) -> UIView?{
        var property = self.tagProperty as? TableViewProperty
        if let pro = property?.sectionView[tagId] {
            var view = pro.getView()
            view.renderTheView(target)
            view.renderDataBinding(bind)
            return view
        }
        return nil
    }
    
    var reusableViews:Dictionary<String,UIView>{
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &UITableViewCellHandle) {
                return d as! Dictionary<String,UIView>
            }else{
                return  Dictionary<String,UIView>()
            }
        }set (value){
            objc_setAssociatedObject(self, &UITableViewCellHandle, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    override func subRender(scene:EUScene) {
        let property = self.tagProperty as! TableViewProperty
        scene.eu_tableViewDataSource = nil
        scene.eu_tableViewDataSource = UITableViewDataSourceBond(tableView: self)
        scene.eu_tableViewDidLoad(self)
    }
    
    public func dequeueReusableCell(reuseId:String,target:EUScene,bind:EZViewModel? = nil) -> UITableViewCell{
        var cell = self.dequeueReusableCellWithIdentifier(reuseId) as! UITableViewCell
        if cell.contentView.subviews.count == 0 {
            SwiftTryCatch.try({
                var property = self.tagProperty as! TableViewProperty
                if let cellProperty = property.reuseCell[reuseId] {
                var view = cellProperty.getView()
                cell.contentView.addSubview(view)
                view.renderTheView(target)
            }}, catch: { (error) in
                println(self.nameOfClass + "Error:\(error.description)")
            }, finally:nil)
        }
        if let view = cell.contentView.subviews.first as? UIView {
            view.renderDataBinding(bind)
        }
        return cell
    }
}

private var UICollectionViewCellHandle :UInt8 = 5
extension UICollectionView {
    
    var reusableViews:Dictionary<String,UIView>{
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &UICollectionViewCellHandle) {
                return d as! Dictionary<String,UIView>
            }else{
                return  Dictionary<String,UIView>()
            }
        }set (value){
            objc_setAssociatedObject(self, &UICollectionViewCellHandle, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    override func subRender(scene:EUScene) {
        let property = self.tagProperty as! CollectionViewProperty
        scene.eu_collectionViewDataSource = nil
        scene.eu_collectionViewDataSource = UICollectionViewDataSourceBond(collectionView: self)
        scene.eu_collectionViewDidLoad(self)
    }
    
    public func dequeueReusableCell(reuseId:String,forIndexPath:NSIndexPath,target:EUScene,bind:EZViewModel? = nil) -> UICollectionViewCell{
        var cell = self.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: forIndexPath) as! UICollectionViewCell
        if cell.contentView.subviews.count == 0 {
            SwiftTryCatch.try({
                var property = self.tagProperty as! CollectionViewProperty
                if let cellProperty = property.reuseCell[reuseId] {
                var view = cellProperty.getView()
                cell.contentView.addSubview(view)
                view.renderTheView(target)
            }}, catch: { (error) in
                println(self.nameOfClass + "Error:\(error.description)")
            }, finally: nil)
        }
        if let view = cell.contentView.subviews.first as? UIView {
            view.renderDataBinding(bind)
        }
        return cell
    }
}

extension UIScrollView {
    override func renderSelector(scene:EUScene){
        var property =  self.tagProperty as? ScrollViewProperty
        
        if let pullRefresh = property?.pullToRefresh {
            var target:AnyObject!
            if !isEmpty(pullRefresh.target){
                target = scene.valueForKeyPath(pullRefresh.target)
            }else {
                target = scene
            }
            if isEmpty(pullRefresh.viewClass) {
                self.addPullToRefreshWithActionHandler(){
                    NSThread.detachNewThreadSelector(pullRefresh.selector, toTarget:target, withObject: self)
                }
            }else if let view =  NSObject(fromString: pullRefresh.viewClass) as? UIView {
                self.addPullToRefreshWithActionHandler(customer:view) {
                    NSThread.detachNewThreadSelector(pullRefresh.selector, toTarget:target, withObject: self)
                }
            }
        }
        
        if let infiniteScrolling = property?.infiniteScrolling {
            var target:AnyObject!
            if !isEmpty(infiniteScrolling.target){
                target = scene.valueForKeyPath(infiniteScrolling.target)
            }else {
                target = scene
            }
            if isEmpty(infiniteScrolling.viewClass) {
                self.addInfiniteScrollingWithActionHandler(){
                    NSThread.detachNewThreadSelector(infiniteScrolling.selector, toTarget:target, withObject: self)
                }
            }else if let view =  NSObject(fromString: infiniteScrolling.viewClass) as? UIView {
                self.addInfiniteScrollingWithActionHandler(customer:view) {
                    NSThread.detachNewThreadSelector(infiniteScrolling.selector, toTarget:target, withObject: self)
                }
            }
        }
    }
}

