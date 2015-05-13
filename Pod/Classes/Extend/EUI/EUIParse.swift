//
//  EZUI.swift
//  medical
//
//  Created by zhuchao on 15/4/30.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import UIKit
import SnapKit

class EUIParse: NSObject {
    class func ParseHtml(html:String) -> [ViewProperty]{
        var data = ObjectiveGumbo.parseDocumentWithString(html)
        var body = data.elementsWithTag(GUMBO_TAG_BODY).first as! OGElement
        var viewArray = [ViewProperty]()
        for element in body.children {
            if element.isKindOfClass(OGElement) {
                if let pro = self.loopElement(element as! OGElement) {
                    viewArray.append(pro)
                }
            }
        }
        return viewArray
    }
    
    // 对子节点进行递归解析
    class func loopElement(pelement:OGElement) -> ViewProperty?{
        var tagProperty:ViewProperty?
        
        var type = self.string(pelement,key:"type")
        if type == "UIScrollView" {
            tagProperty = ScrollViewProperty()
        }else if type == "UITableView"{
            tagProperty = TableViewProperty()
        }else if type == "UICollectionView"{
            tagProperty = CollectionViewProperty()
        }else if pelement.tag.value == GUMBO_TAG_IMG.value {
            tagProperty = ImageProperty()
        }else if pelement.tag.value == GUMBO_TAG_SPAN.value {
            tagProperty = LabelProperty()
        }else if pelement.tag.value == GUMBO_TAG_BUTTON.value {
            tagProperty = ButtonProperty()
        }else if pelement.tag.value == GUMBO_TAG_INPUT.value{
            tagProperty = TextFieldProperty()
        }else if pelement.tag.value == GUMBO_TAG_DIV.value{
            tagProperty = ViewProperty()
        }
        if tagProperty != nil {
            tagProperty!.renderTag(pelement)
        }
        
        return tagProperty
    }
    
    class func string (element:OGElement,key:String) ->String?{
        if let str = element.attributes?[key] as? String {
            return str
        }
        return nil
    }
    
    class func getStyleProperty (element:OGElement,key:String) -> Array<Constrain>? {
        if element.attributes?[key] == nil {
            return nil
        }
        var style = Array<Constrain>()
        var origin = element.attributes?[key] as! String
        var firstArray = origin.trimArrayBy(";")
        
        for str in firstArray {
            var secondArray = str.trimArrayBy(":")
            if secondArray.count == 2 {
                var raw = secondArray[0] as String
                let rawKey = CSS(rawValue: key+"-"+raw.trim)
                if rawKey == nil {
                    continue
                }
                var values = secondArray[1].trimArray
                if key == "align" {
                    switch rawKey! {
                    case .AlignTop,.AlignBottom,.AlignLeft,.AlignRight,.AlignCenterX,.AlignCenterY:
                        if values.count == 1 {
                            style.append(Constrain(name:rawKey!,value: values[0].trim.floatValue))
                        }else if(values.count >= 2){
                            style.append(Constrain(name:rawKey!,value: values[0].trim.floatValue,target:values[1].trim))
                        }
                    case .AlignCenter:
                        if values.count >= 1 {
                            style.append(Constrain(name:.AlignCenterX,value: values[0].trim.floatValue))
                        }
                        if values.count >= 2 {
                            style.append(Constrain(name:.AlignCenterY,value: values[1].trim.floatValue))
                        }
                    case .AlignEdge:
                        if values.count >= 1 && values[0].trim != "*" {
                            style.append(Constrain(name:.AlignTop,value: values[0].trim.floatValue))
                        }
                        if values.count >= 2 && values[1].trim != "*" {
                            style.append(Constrain(name:.AlignLeft,value: values[1].trim.floatValue))
                        }
                        if values.count >= 3 && values[2].trim != "*" {
                            style.append(Constrain(name:.AlignBottom,value: values[2].trim.floatValue))
                        }
                        if values.count >= 4 && values[3].trim != "*" {
                            style.append(Constrain(name:.AlignRight,value: values[3].trim.floatValue))
                        }
                    default :
                        println(raw.trim + " is jumped")
                    }

                }else if key == "margin" {
                    switch rawKey! {
                    case .MarginTop,.MarginBottom,.MarginLeft,.MarginRight:
                        if values.count == 1 {
                            style.append(Constrain(name:rawKey!,value: values[0].trim.floatValue))
                        }else if(values.count >= 2){
                            style.append(Constrain(name:rawKey!,value: values[0].trim.floatValue,target:values[1].trim))
                        }
                    default :
                        println(raw.trim + " is jumped")
                    }

                }
            }else if secondArray.count == 1 &&  key == "align" {
                
                var values = secondArray[0].trimArray
                if values.count >= 1 && values[0].trim != "*" {
                    style.append(Constrain(name:.AlignTop,value: values[0].trim.floatValue))
                }
                if values.count >= 2 && values[1].trim != "*" {
                    style.append(Constrain(name:.AlignLeft,value: values[1].trim.floatValue))
                }
                if values.count >= 3 && values[2].trim != "*" {
                    style.append(Constrain(name:.AlignBottom,value: values[2].trim.floatValue))
                }
                if values.count >= 4 && values[3].trim != "*" {
                    style.append(Constrain(name:.AlignRight,value: values[3].trim.floatValue))
                }
            }
        }
        return style

    }
}

