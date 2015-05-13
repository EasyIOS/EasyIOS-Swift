//
//  NSString+OGString.h
//  Hacker News
//
//  Created by Thomas Denney on 30/08/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OGString)

-(NSString*)escapedString;
+(NSString*)indentationString:(int)indentationLevel;

@end
