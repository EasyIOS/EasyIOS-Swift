//
//  EUI+CollectionViewProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import Bond

class CollectionViewProperty: ScrollViewProperty {
    var separatorInset:UIEdgeInsets?
    var reuseCell = Dictionary<String,ViewProperty>()
    var flowLayout = Dictionary<String,String>()
    var layout:String?
    
    override func view() -> UICollectionView{
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: self.getLayout())
        view.tagProperty = self
        
        self.renderViewStyle(view)
        for (reuseId,_) in self.reuseCell {
            view.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }
        return view
    }
    
    override func renderTag(pelement:OGElement){
        self.tagOut += ["delegate","datasource","flow-layout","layout"]
        
        super.renderTag(pelement)
        if let layout = EUIParse.string(pelement, key: "flow-layout") {
            let dict = layout.trimArrayBy(";")
            for value in dict {
                var array = value.trimArrayBy(":")
                let key = array[0] as String
                let val = array[1] as String
                self.flowLayout[key.toKeyPath] = val
            }
        }
        self.layout = EUIParse.string(pelement, key: "layout")
    }

    func getLayout() -> UICollectionViewLayout{
        if let customlayout = self.layout,let nsobject = NSObject(fromString: customlayout) as? UICollectionViewLayout {
            return nsobject
        }
        
        let layout = UICollectionViewFlowLayout()
        for (key,value) in self.flowLayout{
            if key == "minimumLineSpacing" || key == "minimumInteritemSpacing"{
                layout.setValue(value.floatValue, forKeyPath: key)
            }else if key == "itemSize" {
                layout.itemSize = CGSizeFromString(value)
            }else if key == "estimatedItemSize" {
                layout.estimatedItemSize = CGSizeFromString(value)
            }else if key == "headerReferenceSize" {
                layout.headerReferenceSize = CGSizeFromString(value)
            }else if key == "footerReferenceSize"{
                layout.footerReferenceSize = CGSizeFromString(value)
            }else if key == "sectionInset" {
                layout.sectionInset = UIEdgeInsetsFromString(value)
            }else if key == "scrollDirection" {
                if value.lowercaseString == "Vertical".lowercaseString {
                    layout.scrollDirection = .Vertical
                }else if value.lowercaseString == "Horizontal".lowercaseString {
                    layout.scrollDirection = .Horizontal
                }
            }
        }
        return layout
    }
    
    override func childLoop(pelement: OGElement) {
        for element in pelement.children {
            if let ele = element as? OGElement,
                let type = EUIParse.string(ele, key: "type"),
                let tagId = EUIParse.string(ele, key: "id"),
                let property = EUIParse.loopElement(ele){
                if type.lowercaseString == "cell"  {
                    self.reuseCell[tagId] = property
                }
            }
        }
    }

}
