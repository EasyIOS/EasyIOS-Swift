//
//  OGElement.m
//  ObjectiveGumbo
//
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "OGElement.h"

@implementation OGElement

-(NSString*)text
{
    NSMutableString * text = [NSMutableString new];
    for (OGNode * child in self.children)
    {
        [text appendString:[child text]];
    }
    return text;
}

-(NSString*)htmlWithIndentation:(int)indentationLevel
{
    NSMutableString * html = [NSMutableString stringWithFormat:@"<%@", [OGUtility tagForGumboTag:self.tag]];
    for (NSString * attribute in self.attributes)
    {
        [html appendFormat:@" %@=\"%@\"", attribute, [self.attributes[attribute]  escapedString]];
    }
    if (self.children.count == 0)
    {
        [html appendString:@" />\n"];
    }
    else
    {
        [html appendString:@">\n"];
        for (OGNode * child in self.children)
        {
            [html appendString:[child htmlWithIndentation:indentationLevel + 1]];
        }
        [html appendFormat:@"</%@>\n", [OGUtility tagForGumboTag:self.tag]];
    }
    return html;
}

-(NSArray*)selectWithBlock:(SelectorBlock)block
{
    NSMutableArray * matchingChildren = [NSMutableArray new];
    for (OGNode * child in self.children)
    {
        if (block(child))
        {
            [matchingChildren addObject:child];
        }
        [matchingChildren addObjectsFromArray:[child selectWithBlock:block]];
    }
    return matchingChildren;
}

-(NSArray*)elementsWithAttribute:(NSString *)attribute andValue:(NSString *)value
{
    return [self selectWithBlock:^BOOL(id node) {
        if ([node isKindOfClass:[OGElement class]])
        {
            OGElement * element = (OGElement*)node;
            return [element.attributes[attribute] isEqualToString:value];
        }
        return NO;
    }];
}

-(NSArray*)elementsWithClass:(NSString*)class
{
    return [self selectWithBlock:^BOOL(id node) {
        if ([node isKindOfClass:[OGElement class]])
        {
            OGElement * element = (OGElement*)node;
            for (NSString * classes in element.classes)
            {
                if ([classes isEqualToString:class])
                {
                    return YES;
                }
            }
        }
        return NO;
    }];
}

-(NSArray*)elementsWithID:(NSString *)elementId
{
    return [self selectWithBlock:^BOOL(id node) {
        if ([node isKindOfClass:[OGElement class]]) {
            OGElement * element = (OGElement*)node;
            return [(NSString*)element.attributes[@"id"] isEqualToString:elementId];
        }
        return NO;
    }];
}

-(NSArray*)elementsWithTag:(GumboTag)tag
{
    return [self selectWithBlock:^BOOL(id node) {
        if ([node isKindOfClass:[OGElement class]])
        {
            OGElement * element = (OGElement*)node;
            return element.tag == tag;
        }
        return NO;
    }];
}

@end
