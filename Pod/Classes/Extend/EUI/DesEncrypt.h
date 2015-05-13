//
//  DesEncrypt.h
//  medical
//
//  Created by zhuchao on 15/5/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEncrypt : NSObject
+ (NSString *)encryptWithText:(NSString *)sText key:(NSString *)key;//加密
+ (NSString *)decryptWithText:(NSString *)sText key:(NSString *)key;//解密
@end
