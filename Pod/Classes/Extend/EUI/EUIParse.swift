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
        let data = ObjectiveGumbo.parseDocumentWithString(html)
        let body = data.elementsWithTag(GUMBO_TAG_BODY).first as! OGElement
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
        var type:String?
        
        switch (pelement.tag.rawValue){
            case GUMBO_TAG_IMG.rawValue :
                type = "UIImageView"
            case GUMBO_TAG_SPAN.rawValue :
                type = "UILabel"
            case GUMBO_TAG_BUTTON.rawValue :
                type = "UIButton"
            case GUMBO_TAG_INPUT.rawValue :
                type = "UITextField"
            default :
                type = self.string(pelement,key:"type")
        }
        
        if let atype = type {
            switch (atype){
            case "UIScrollView","scroll":
                tagProperty = ScrollViewProperty()
            case "UITableView","table":
                tagProperty = TableViewProperty()
            case "UICollectionView","collection":
                tagProperty = CollectionViewProperty()
            case "UIImageView","imageView":
                tagProperty = ImageProperty()
            case "UILabel","label":
                tagProperty = LabelProperty()
            case "UIButton","button":
                tagProperty = ButtonProperty()
            case "UITextField","field":
                tagProperty = TextFieldProperty()
            default :
                tagProperty = ViewProperty()
            }
        }else{
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
        let origin = element.attributes?[key] as! String
        let firstArray = origin.trimArrayBy(";")
        
        for str in firstArray {
            var secondArray = str.trimArrayBy(":")
            if secondArray.count == 2 {
                let raw = secondArray[0] as String
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
                        print(raw.trim + " is jumped")
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
                        print(raw.trim + " is jumped")
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

