//
//  EUI+TableViewProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/2.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import Bond

class TableViewProperty:ScrollViewProperty{
    var tableViewStyle = UITableViewStyle.Plain
    var separatorInset:UIEdgeInsets?
    var rowHeight = UITableViewAutomaticDimension
    
    var reuseCell = Dictionary<String,ViewProperty>()
    var sectionView = Dictionary<String,ViewProperty>()
    var separatorStyle = UITableViewCellSeparatorStyle.SingleLine

    override func view() -> UITableView{
        let view = UITableView(frame: CGRectZero, style: self.tableViewStyle)
        view.tagProperty = self
        view.rowHeight = self.rowHeight
        view.separatorStyle = self.separatorStyle;
        
        if let inset = self.separatorInset {
            view.separatorInset = inset;
        }

        self.renderViewStyle(view)
        for (reuseId,_) in self.reuseCell {
            view.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        }
        return view
    }
    

    override func renderTag(pelement:OGElement){
        self.tagOut += ["table-view-style","separator-inset","delegate","datasource","row-height","separator-style"]
        
        super.renderTag(pelement)
        if let style = EUIParse.string(pelement,key:"table-view-style") {
            self.tableViewStyle = style.tableViewStyle
        }

        if let rowHeight = EUIParse.string(pelement, key: "row-height") {
            self.rowHeight = rowHeight.floatValue
        }
        
        if let separatorInset = EUIParse.string(pelement,key:"separator-inset") {
            self.separatorInset = UIEdgeInsetsFromString(separatorInset)
        }
        
        if let separatorStyle = EUIParse.string(pelement, key: "separator-style") {
            self.separatorStyle = separatorStyle.separatorStyle
        }
    }
    
    override func childLoop(pelement: OGElement) {
        for element in pelement.children {
            if let ele = element as? OGElement,
                let type = EUIParse.string(ele, key: "type"),
                let tagId = EUIParse.string(ele, key: "id"),
                let property = EUIParse.loopElement(ele){
                    
                if type.lowercaseString == "cell" || type.lowercaseString == "UITableViewCell" {
                    self.reuseCell[tagId] = property
                }else if type.lowercaseString == "section" || type.lowercaseString == "UITableViewSection"{
                    self.sectionView[tagId] = property
                }
            }
        }
    }
    
}