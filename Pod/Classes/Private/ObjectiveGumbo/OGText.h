//
//  OGText.h
//  ObjectiveGumbo
//
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "OGNode.h"

@interface OGText : OGNode
{
    NSString * _text;
}

@property BOOL isComment;
@property BOOL isCData;
@property BOOL isWhitespace;
@property BOOL isText;

-(id)initWithText:(NSString*)text andType:(GumboNodeType)type;

@end
