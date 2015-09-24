//
//  EZPrintln.swift
//  medical
//
//  Created by zhuchao on 15/4/28.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation

var EZ_DEBUG_MODE = true
/**
Writes the textual representation of `object` and a newline character into the standard output.
The textual representation is obtained from the `object` using its protocol conformances,
in the following order of preference: `Streamable`, `Printable`, `DebugPrintable`.
This functional also augments the original function with the filename, function name, and line number of the object that is being logged.
- parameter object:   A textual representation of the object.
- parameter file:     Defaults to the name of the file that called magic(). Do not override this default.
- parameter function: Defaults to the name of the function within the file in which magic() was called. Do not override this default.
- parameter line:     Defaults to the line number within the file in which magic() was called. Do not override this default.
*/
public func EZPrintln<T>(object: T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
{
    if EZ_DEBUG_MODE {
        let filename = NSURL(fileURLWithPath: file).lastPathComponent?.URLString
        print("\(filename).\(function)[\(line)]: \(object)\n", terminator: "")
    }
}

