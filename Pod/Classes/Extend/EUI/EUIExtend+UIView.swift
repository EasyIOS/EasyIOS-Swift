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
import SDWebImage

private var UIViewTagIdHandle :UInt8 = 1
private var UIViewViewPropertyHandle :UInt8 = 2
private var UIViewConstraintGroupHandle :UInt8 = 3
private var UIViewWatchHandle :UInt8 = 4
private var TableViewDataSourceBond :UInt8 = 6
private var CollectionViewDataSourceBond :UInt8 = 6

extension EUScene{
    func loadEZLayout(html:String){
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
            }, finally: {
                // close resources
        })
    }
    
    public var eu_tableViewDataSource: UITableViewDataSourceBond<UITableViewCell>? {
        get{
            let d: AnyObject = objc_getAssociatedObject(self, &TableViewDataSourceBond)
            return d as? UITableViewDataSourceBond<UITableViewCell>
        }set (value){
            objc_setAssociatedObject(self, &TableViewDataSourceBond, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    public var eu_collectionViewDataSource: UICollectionViewDataSourceBond<UICollectionViewCell>? {
        get{
            let d: AnyObject = objc_getAssociatedObject(self, &CollectionViewDataSourceBond)
            return d as? UICollectionViewDataSourceBond<UICollectionViewCell>
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
            if view.tagProperty != nil && view.tagProperty.tagId == tagId {
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
    
    
    func subRender(scene:EUScene,bind:EZViewModel? = nil) {
        for subView in self.subviews {
            var view = subView as! UIView
            view.renderTheView(scene,bind: bind)
        }
    }
    
    func renderTheView(scene:EUScene,bind:EZViewModel? = nil){
        self.subRender(scene,bind: bind)
        self.renderDataBinding(bind)
        self.renderSelector(scene)
        self.renderGesture(scene)
        self.renderLayout()
    }
    
    func renderDataBinding(bind:EZViewModel?){
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
    override func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["src"] {
            if let image = bind!.valueForKey(bindKey) as? EZImage {
                image.dym! ->> self.dynImage
            }else if let src = bind!.valueForKey(bindKey) as? EZURL {
                src.dym! *->> Bond<NSURL?>{ value in
                    self.sd_setImageWithURL(value)
                }
            }
        }else if let bindKey = self.tagProperty.bind["image"] {
            if let image = bind!.valueForKey(bindKey) as? EZImage {
                image.dym! ->> self.dynImage
            }
        }
    }
}

private var textColorDynamicHandleUILabel: UInt8 = 0;
extension UILabel {
    override func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["text"] {
            if let text = bind!.valueForKey(bindKey) as? EZAttributedString {
                text.dym! ->> self.dynAttributedText
            }else if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym! ->> self.dynText
            }
        }
        if let bindKey = self.tagProperty.bind["text-color"] {
            if let color = bind!.valueForKey(bindKey) as? EZColor {
                color.dym! ->> self.dynTextColor
            }
        }
    }
    
    public var dynTextColor: Dynamic<UIColor> {
        if let d: AnyObject = objc_getAssociatedObject(self, &textColorDynamicHandleUILabel) {
            return (d as? Dynamic<UIColor>)!
        } else {
            let d = InternalDynamic<UIColor>(self.textColor ?? UIColor.clearColor())
            let bond = Bond<UIColor>() { [weak self] v in if let s = self { s.textColor = v } }
            d.bindTo(bond, fire: false, strongly: false)
            d.retain(bond)
            objc_setAssociatedObject(self, &textColorDynamicHandleUILabel, d, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return d
        }
    }
}

extension UITextField {
    override func renderDataBinding(bind:EZViewModel?){
        super.renderDataBinding(bind)
        if let bindKey = self.tagProperty.bind["text"] {
             if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym! ->> self.dynText
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
    
    override func subRender(scene:EUScene,bind:EZViewModel? = nil) {
        let property = self.tagProperty as! TableViewProperty
        scene.eu_tableViewDataSource = nil
        scene.eu_tableViewDataSource = UITableViewDataSourceBond(tableView: self)
        scene.eu_tableViewDidLoad(self)
    }
    
    public func dequeueReusableCell(reuseId:String,target:EUScene,bind:EZViewModel? = nil) -> UITableViewCell{
        var cell = self.dequeueReusableCellWithIdentifier(reuseId) as! UITableViewCell
        if cell.contentView.subviews.count == 0 {
            var property = self.tagProperty as! TableViewProperty
            if let cellProperty = property.reuseCell[reuseId] {
                SwiftTryCatch.try({
                    var view = cellProperty.getView()
                    cell.contentView.addSubview(view)
                    view.renderTheView(target,bind:bind)
                    }, catch: { (error) in
                        println(self.nameOfClass + "Error:\(error.description)")
                    }, finally: {
                })
            }
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
    
    override func subRender(scene:EUScene,bind:EZViewModel? = nil) {
        let property = self.tagProperty as! CollectionViewProperty
        scene.eu_collectionViewDataSource = nil
        scene.eu_collectionViewDataSource = UICollectionViewDataSourceBond(collectionView: self)
        scene.eu_collectionViewDidLoad(self)
    }
    
    public func dequeueReusableCell(reuseId:String,forIndexPath:NSIndexPath,target:EUScene,bind:EZViewModel? = nil) -> UICollectionViewCell{
        var cell = self.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: forIndexPath) as! UICollectionViewCell
        
        if cell.contentView.subviews.count == 0 {
            var property = self.tagProperty as! CollectionViewProperty
            if let cellProperty = property.reuseCell[reuseId] {
                SwiftTryCatch.try({
                    var view = cellProperty.getView()
                    cell.contentView.addSubview(view)
                    view.renderTheView(target,bind:bind)
                    }, catch: { (error) in
                        println(self.nameOfClass + "Error:\(error.description)")
                    }, finally: {
                })
            }
        }
        return cell
    }
}



