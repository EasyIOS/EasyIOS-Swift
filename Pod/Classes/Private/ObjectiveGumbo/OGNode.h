//
//  OGNode.h
//  ObjectiveGumbo
//
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGUtility.h"
#import "NSString+OGString.h"

typedef BOOL(^SelectorBlock)(id node);

@interface OGNode : NSObject

@property OGNode * parent;

-(NSString*)text;
-(NSString*)html;
-(NSString*)htmlWithIndentation:(int)indentationLevel;

//Usage:
//#stuffwiththisid .orthisclass orthistag
-(NSArray*)select:(NSString*)selector;
-(NSArray*)selectWithBlock:(SelectorBlock)block;

//Returns the first OGNode from the select:
-(OGNode*)first:(NSString*)selector;
-(OGNode*)last:(NSString*)selector;

-(NSArray*)elementsWithClass:(NSString*)class;
-(NSArray*)elementsWithID:(NSString*)id;
-(NSArray*)elementsWithTag:(GumboTag)tag;

@end
