//
//  EUI+ImageProperty.swift
//  medical
//
//  Created by zhuchao on 15/5/1.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

class ImageProperty:ViewProperty{
    var src = ""
    override func view() -> UIImageView{
        let view = UIImageView()
        view.tagProperty = self
        if !self.src.characters.isEmpty {
            if self.src.hasPrefix("http") {
                view.kf_setImageWithURL(NSURL(string: self.src)!)
            }else{
                view.image = UIImage(named: self.src)
            }
        }
        self.renderViewStyle(view)
        for subTag in self.subTags {
            view.addSubview(subTag.getView())
        }
        return view
    }
    
    override func renderTag(pelement:OGElement){
        self.tagOut += ["src"]
        
        super.renderTag(pelement)
        if let src = EUIParse.string(pelement,key:"src"),let filterHtml = self.bindTheKeyPath(src, key: "src") {
            self.src = filterHtml
        }
        
    }
    
    override func childLoop(pelement: OGElement) {
        
    }

}
