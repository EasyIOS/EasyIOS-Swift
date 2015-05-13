//
//  OGUtility.h
//  Hacker News
//
//  Created by Thomas Denney on 30/08/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gumbo.h"

@interface OGUtility : NSObject

+(NSString*)tagForGumboTag:(GumboTag)tag;
+(GumboTag)gumboTagForTag:(NSString*)tag;
+(NSArray*)tagStrings;

@end
