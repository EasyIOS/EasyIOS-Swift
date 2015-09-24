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
private var UIViewDisposeBag :UInt8 = 5
//private var CollectionViewDataSourceBond :UInt8 = 6
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
            objc_setAssociatedObject(self, &attributedLabelDelegateHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func eu_viewByTag(tagId:String) ->UIView?{
        if let subViews = self.eu_subViews {
            for view in subViews {
                if view.subviews.count > 0 {
                    if let aview = view.getSubViewByTagId(tagId){
                        return aview
                    }
                }
                if view.tagProperty.tagId == tagId {
                    return view
                }
            }
        }
        return nil
    }

    func loadEZLayout(){
        self.view.clearEZView()
        if let subViews = self.eu_subViews {
            for view in subViews {
                self.view.addSubview(view)
            }
            self.view.subRender(self)
        }
        
        self.context.setObject(self, forKeyedSubscript: "document")
        self.eval(self.scriptString)
        self.eu_viewDidLoad()
    }
}

extension UIView {
    
    public var disposeBag:DisposeBag?{
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &UIViewDisposeBag) {
                return d as? DisposeBag
            }else{
                return nil
            }
        }set(b){
            objc_setAssociatedObject(self, &UIViewDisposeBag, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public class func formTag(tag:String) -> UIView {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) {
                return view
            }
        }
        return UIView()
    }
    
    func clearEZView(){
        for view in self.subviews {
            let aview = view 
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
            objc_setAssociatedObject(self, &UIViewViewPropertyHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
                return view 
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
            let view = subView 
            view.renderTheView(scene)
        }
    }
    
    func renderTheView(scene:EUScene){
        self.subRender(scene)
        self.renderSelector(scene)
        self.renderGesture(scene)
        self.renderLayout()
    }
    
    public func renderDataBinding(scene:EUScene,bind:NSObject?){
        for subView in self.subviews {
            subView.renderDataBinding(scene,bind: bind)
        }
        let property =  self.tagProperty as ViewProperty
        
        if let bindKey = property.bind["background-color"] {
            if let color = bind!.valueForKey(bindKey) as? EZColor {
                color.dym!.bindTo(self.bnd_backgroundColor)
            }
        }
        if let bindKey = property.bind["alpha"] {
            if let alpha = bind!.valueForKey(bindKey) as? EZFloat {
                alpha.dym!.bindTo(self.bnd_alpha)
            }
        }
        if let bindKey = property.bind["hidden"] {
            if let hidden = bind!.valueForKey(bindKey) as? EZBool {
                hidden.dym!.bindTo(self.bnd_hidden)
            }
        }
        
        self.disposeBag?.dispose()
        if let selector = property.onTapBind {
            if self.disposeBag == nil {
                self.disposeBag = DisposeBag()
            }
            self.disposeBag?.addDisposable(self.whenTap(selector.tapNumber){
                let script = Regex("\\{\\{(\\w+)\\}\\}").replace(selector.selector, withBlock: { (regx) -> String in
                    let bindKey = regx.subgroupMatchAtIndex(0)?.trim
                    if let value = bind!.valueForKey(bindKey!) as? String{
                        return value
                    }else if let value = bind!.valueForKey(bindKey!) as? Int{
                        return String(value)
                    }else if let value = bind!.valueForKey(bindKey!) as? Bool{
                        return value ? "true" : "false"
                    }
                    return ""
                })
                scene.eval(script)
            })
        }
        
        if let selector = property.onSwipeBind {
            if self.disposeBag == nil {
                self.disposeBag = DisposeBag()
            }
            self.disposeBag?.addDisposable(self.whenSwipe(selector.numberOfTouches, direction: selector.direction){
                let script = Regex("\\{\\{(\\w+)\\}\\}").replace(selector.selector, withBlock: { (regx) -> String in
                    let bindKey = regx.subgroupMatchAtIndex(0)?.trim
                    if let value = bind!.valueForKey(bindKey!) as? String{
                        return value
                    }else if let value = bind!.valueForKey(bindKey!) as? Int{
                        return String(value)
                    }else if let value = bind!.valueForKey(bindKey!) as? Bool{
                        return value ? "true" : "false"
                    }
                    return ""
                })
                scene.eval(script)
            })
        }
        
    }

    
    func renderGesture(scene:EUScene){
        let property =  self.tagProperty as ViewProperty
        
        self.disposeBag?.dispose()
        if let selector = property.onTap {
            if self.disposeBag == nil {
                self.disposeBag = DisposeBag()
            }
            self.disposeBag?.addDisposable(self.whenTap(selector.tapNumber){
                scene.eval(selector.selector)
            })
        }
        
        if let selector = property.onSwipe {
            if self.disposeBag == nil {
                self.disposeBag = DisposeBag()
            }
            self.disposeBag?.addDisposable(self.whenSwipe(selector.numberOfTouches, direction: selector.direction){
                scene.eval(selector.selector)
            })
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
                let targetView = self.getViewById(cons.target)
                let value = cons.value
                let key = cons.constrainName
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
    override public class func formTag(tag:String) -> UIImageView {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UIImageView {
                return view
            }
        }
        return UIImageView()
    }
    
    override public func renderDataBinding(scene:EUScene,bind:NSObject?){
        super.renderDataBinding(scene,bind: bind)
        if let bindKey = self.tagProperty.bind["src"] {
            if let image = bind!.valueForKey(bindKey) as? EZImage {
                image.dym!.bindTo(self.bnd_image)
            }else if let src = bind!.valueForKey(bindKey) as? EZURL {
                src.dym!.bindTo(self.bnd_URLImage)
            }else if let image = bind!.valueForKey(bindKey) as? UIImage {
                self.image = image
            }else if let url = bind!.valueForKey(bindKey) as? NSURL {
                self.kf_setImageWithURL(url)
            }else if let str = bind!.valueForKey(bindKey) as? String {
                if let image = UIImage(named: str) {
                    self.image = image
                }else if let url = NSURL(string: str) {
                    self.kf_setImageWithURL(url)
                }
            }
        }else if let bindKey = self.tagProperty.bind["image"] {
            if let image = bind!.valueForKey(bindKey) as? EZImage {
                image.dym!.bindTo(self.bnd_image)
            }else if let image = bind!.valueForKey(bindKey) as? UIImage {
                self.image = image
            }
        }
    }
}

extension UILabel {
    override public class func formTag(tag:String) -> UILabel {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UILabel {
                return view
            }
        }
        return UILabel()
    }
    
    override public func renderDataBinding(scene:EUScene,bind:NSObject?){
        super.renderDataBinding(scene,bind: bind)
        if let bindKey = self.tagProperty.bind["text"] {
            if let text = bind!.valueForKey(bindKey) as? EZAttributedString {
                text.dym!.bindTo(self.bnd_attributedText)
            }else if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym!.bindTo(self.bnd_text)
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
                color.dym!.bindTo(self.bnd_textColor)
            }else if let color = bind!.valueForKey(bindKey) as? UIColor {
                self.textColor = color
            }
        }
    }
}

extension TTTAttributedLabel {
    override public class func formTag(tag:String) -> TTTAttributedLabel {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? TTTAttributedLabel {
                return view
            }
        }
        return TTTAttributedLabel(frame: CGRectZero)
    }
    
    override public func renderDataBinding(scene:EUScene,bind:NSObject?){
        super.renderDataBinding(scene,bind: bind)
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
            self.delegate = delegate
        }
    }
}

extension UITextField {
    override public class func formTag(tag:String) -> UITextField {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UITextField {
                return view
            }
        }
        return UITextField()
    }
    
    override public func renderDataBinding(scene:EUScene,bind:NSObject?){
        super.renderDataBinding(scene,bind:bind)
        if let bindKey = self.tagProperty.bind["text"] {
            if let text = bind!.valueForKey(bindKey) as? EZString {
                text.dym!.bindTo(self.bnd_text)
            }else if let text = bind!.valueForKey(bindKey) as? String {
                self.text = text
            }
        }
    }
}

extension UIButton {
    override public class func formTag(tag:String) -> UIButton {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UIButton {
                return view
            }
        }
        return UIButton()
    }
    
    override func renderSelector(scene:EUScene){
        let property =  self.tagProperty as? ButtonProperty
        if let selector = property?.onEvent {
            self.bnd_controlEvent.filter{$0 == selector.event}.map{ e in}.observe({
                scene.eval(selector.selector)
            })
        }
    }
}

private var UITableViewCellHandle :UInt8 = 5
extension UITableView {
    override public class func formTag(tag:String) -> UITableView {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UITableView {
                return view
            }
        }
        return UITableView()
    }
    
    public func getSectionViewByTagId(tagId:String,target:EUScene,bind:NSObject? = nil) -> UIView?{
        let property = self.tagProperty as? TableViewProperty
        if let pro = property?.sectionView[tagId] {
            let view = pro.getView()
            view.renderTheView(target)
            view.renderDataBinding(target,bind: bind)
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
            objc_setAssociatedObject(self, &UITableViewCellHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override func subRender(scene:EUScene) {
        scene.eu_tableViewDidLoad(self)
    }
    
    public func dequeueReusableCell(reuseId:String,forIndexPath:NSIndexPath,target:EUScene,bind:NSObject? = nil) -> UITableViewCell{
        let cell = self.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: forIndexPath)
        if cell.contentView.subviews.count == 0 {
            SwiftTryCatch.`try`({
                let property = self.tagProperty as! TableViewProperty
                if let cellProperty = property.reuseCell[reuseId] {
                    let view = cellProperty.getView()
                    cell.contentView.addSubview(view)
                    view.renderTheView(target)
                }}, `catch`: { (error) in
                    print(self.nameOfClass + "Error:\(error.description)")
                }, finally:nil)
        }
        if let view = cell.contentView.subviews.first {
            view.renderDataBinding(target,bind: bind)
        }
        return cell
    }
}

private var UICollectionViewCellHandle :UInt8 = 5
extension UICollectionView {
    override public class func formTag(tag:String) -> UICollectionView {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UICollectionView {
                return view
            }
        }
        return UICollectionView()
    }
    
    var reusableViews:Dictionary<String,UIView>{
        get{
            if let d: AnyObject = objc_getAssociatedObject(self, &UICollectionViewCellHandle) {
                return d as! Dictionary<String,UIView>
            }else{
                return  Dictionary<String,UIView>()
            }
        }set (value){
            objc_setAssociatedObject(self, &UICollectionViewCellHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override func subRender(scene:EUScene) {
        scene.eu_collectionViewDidLoad(self)
    }
    
    public func dequeueReusableCell(reuseId:String,forIndexPath:NSIndexPath,target:EUScene,bind:NSObject? = nil) -> UICollectionViewCell{
        let cell = self.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: forIndexPath)
        if cell.contentView.subviews.count == 0 {
            SwiftTryCatch.`try`({
                let property = self.tagProperty as! CollectionViewProperty
                if let cellProperty = property.reuseCell[reuseId] {
                let view = cellProperty.getView()
                cell.contentView.addSubview(view)
                view.renderTheView(target)
            }}, `catch`: { (error) in
                print(self.nameOfClass + "Error:\(error.description)")
            }, finally: nil)
        }
        if let view = cell.contentView.subviews.first{
            view.renderDataBinding(target,bind:bind)
        }
        return cell
    }
}

extension UIScrollView {
    override public class func formTag(tag:String) -> UIScrollView {
        if let scene = URLNavigation.currentViewController() as? EUScene {
            if let view = scene.eu_viewByTag(tag) as? UIScrollView {
                return view
            }
        }
        return UIScrollView()
    }
    
    override func renderSelector(scene:EUScene){
        let property =  self.tagProperty as? ScrollViewProperty
        
        if let pullRefresh = property?.pullToRefresh {
            if pullRefresh.viewClass.characters.isEmpty {
                self.addPullToRefreshWithActionHandler(){
                    scene.eval(pullRefresh.selector)
                }
            }else if let view =  NSObject(fromString: pullRefresh.viewClass) as? UIView {
                self.addPullToRefreshWithActionHandler(view) {
                    scene.eval(pullRefresh.selector)
                }
            }
        }
        
        if let infiniteScrolling = property?.infiniteScrolling {
            if infiniteScrolling.viewClass.characters.isEmpty {
                self.addInfiniteScrollingWithActionHandler(){
                    scene.eval(infiniteScrolling.selector)
                }
            }else if let view =  NSObject(fromString: infiniteScrolling.viewClass) as? UIView {
                self.addInfiniteScrollingWithActionHandler(view) {
                   scene.eval(infiniteScrolling.selector)
                }
            }
        }
    }
}

