
//  EZWatch.swift
//  medical
//
//  Created by zhuchao on 15/4/29.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

func watchForChangesToFilePath(filePath:String,callback:dispatch_block_t) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let fileDescriptor = open(filePath, O_EVTONLY)
    
    if fileDescriptor <= 0 {
        return
    }
    assert(fileDescriptor > 0, "Error could subscribe to events for file at path: \(filePath)")
    let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, UInt(fileDescriptor), DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND, queue)
    dispatch_source_set_event_handler(source){
        let flags = dispatch_source_get_data(source)
        if flags != 0 {
            dispatch_source_cancel(source)
            dispatch_async(dispatch_get_main_queue()){
                 callback()
            }
            let popTime = dispatch_time(DISPATCH_TIME_NOW,  Int64(0.5*Double(NSEC_PER_SEC)))
            dispatch_after(popTime, queue){
                watchForChangesToFilePath(filePath, callback: callback)
            }
        }
    }
    dispatch_source_set_cancel_handler(source){
        close(fileDescriptor)
    }
    dispatch_resume(source)
}





