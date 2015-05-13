//
//  OGNode.m
//  ObjectiveGumbo
//
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "OGNode.h"

@implementation OGNode

-(NSString*)text
{
    return @"";
}

-(NSString*)html
{
    return [self htmlWithIndentation:0];
}

-(NSString*)htmlWithIndentation:(int)indentationLevel
{
    return @"";
}

-(NSArray*)select:(NSString *)selector
{
    NSArray * selectors = [selector componentsSeparatedByString:@" "];
    NSMutableArray * allMatchingObjects = [NSMutableArray new];
    for (NSString * individualSelector in selectors)
    {
        if ([individualSelector hasPrefix:@"#"])
        {
            [allMatchingObjects addObjectsFromArray:[self elementsWithID:[individualSelector substringFromIndex:1]]];
        }
        else if ([individualSelector hasPrefix:@"."])
        {
            [allMatchingObjects addObjectsFromArray:[self elementsWithClass:[individualSelector substringFromIndex:1]]];
        }
        else
        {
            [allMatchingObjects addObjectsFromArray:[self elementsWithTag:[OGUtility gumboTagForTag:individualSelector]]];
        }
    }
    
    //Remove duplicates
    NSOrderedSet * set = [[NSOrderedSet alloc] initWithArray:allMatchingObjects];
    allMatchingObjects = [[NSMutableArray alloc] initWithArray:[set array]];
    
    return allMatchingObjects;
}

-(NSArray*)selectWithBlock:(SelectorBlock)block
{
    return [NSArray new];
}

-(OGNode*)first:(NSString *)selector
{
    return [[self select:selector] firstObject];
}

-(OGNode*)last:(NSString *)selector
{
    return [[self select:selector] lastObject];
}

-(NSArray*)elementsWithClass:(NSString*)class
{
    return [NSArray new];
}

-(NSArray*)elementsWithID:(NSString *)id
{
    return [NSArray new];
}

-(NSArray*)elementsWithTag:(GumboTag)tag
{
    return [NSArray new];
}

@end
