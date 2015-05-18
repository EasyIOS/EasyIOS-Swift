//
//  MainLabelDeleage.swift
//  Demo
//
//  Created by zhuchao on 15/5/17.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import EasyIOS
import TTTAttributedLabel

class MainLabelDeleage: TTTAttributedLabelDelegateHandle {
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        URLManager.pushURL(url, animated: true)
    }
}