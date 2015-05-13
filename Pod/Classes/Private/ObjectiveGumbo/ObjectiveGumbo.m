//
//  ObjectiveGumbo.m
//  ObjectiveGumbo
//
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "ObjectiveGumbo.h"

@implementation ObjectiveGumbo

+(OGNode*)parseNodeWithUrl:(NSURL *)url
{
    NSError * error;
    NSString * string = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error == nil)
    {
        return [ObjectiveGumbo parseNodeWithString:string];
    }
    else
    {
        return nil;
    }
}

+(OGNode*)parseNodeWithData:(NSData *)data
{
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [ObjectiveGumbo parseNodeWithString:string];
}

+(OGNode*)parseNodeWithString:(NSString *)string
{
    GumboOutput * output = [ObjectiveGumbo outputFromString:string];
    OGNode * node = [ObjectiveGumbo objectiveGumboNodeFromGumboNode:output->root];
    gumbo_destroy_output(&kGumboDefaultOptions, output);
    return node;
}

+(OGDocument*)parseDocumentWithUrl:(NSURL *)url
{
    NSError * error;
    NSString * string = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error == nil)
    {
        return [ObjectiveGumbo parseDocumentWithString:string];
    }
    else
    {
        return nil;
    }
}

+(OGDocument*)parseDocumentWithData:(NSData *)data
{
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [ObjectiveGumbo parseDocumentWithString:string];
}

+(OGDocument*)parseDocumentWithString:(NSString *)string
{
    GumboOutput * output = [ObjectiveGumbo outputFromString:string];
    OGDocument * node = (OGDocument*)[ObjectiveGumbo objectiveGumboNodeFromGumboNode:output->document];
    gumbo_destroy_output(&kGumboDefaultOptions, output);
    return node;
}

+(GumboOutput*)outputFromString:(NSString*)string
{
    GumboOutput * output = gumbo_parse(string.UTF8String);
    return output;
}

+(OGNode*)objectiveGumboNodeFromGumboNode:(GumboNode*)gumboNode
{
    OGNode * node;
    if (gumboNode->type == GUMBO_NODE_DOCUMENT)
    {
        OGDocument * documentNode = [[OGDocument alloc] init];
        
        const char * cName = gumboNode->v.document.name;
        const char * cSystemIdentifier = gumboNode->v.document.system_identifier;
        const char * cPublicIdentifier = gumboNode->v.document.public_identifier;
        
        documentNode.name = [[NSString alloc] initWithUTF8String:cName];
        documentNode.systemIdentifier = [[NSString alloc] initWithUTF8String:cSystemIdentifier];
        documentNode.publicIdentifier = [[NSString alloc] initWithUTF8String:cPublicIdentifier];
        
        GumboVector * cChildren = &gumboNode->v.document.children;
        documentNode.children = [ObjectiveGumbo arrayOfObjectiveGumboNodesFromGumboVector:cChildren andParent:documentNode];
        
        node = documentNode;
    }
    else if (gumboNode->type == GUMBO_NODE_ELEMENT)
    {
        OGElement * elementNode = [[OGElement alloc] init];
        
        elementNode.tag = gumboNode->v.element.tag;
        elementNode.tagNamespace = gumboNode->v.element.tag_namespace;
        
        NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
        
        GumboVector * cAttributes = &gumboNode->v.element.attributes;
        
        for (int i = 0; i < cAttributes->length; i++)
        {
            GumboAttribute * cAttribute = (GumboAttribute*)cAttributes->data[i];
            
            const char * cName = cAttribute->name;
            const char * cValue = cAttribute->value;
            
            NSString * name = [[NSString alloc] initWithUTF8String:cName];
            NSString * value = [[NSString alloc] initWithUTF8String:cValue];
            
            [attributes setValue:value forKey:name];
            
            if ([name isEqualToString:@"class"])
            {
                elementNode.classes = [value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        }
        
        elementNode.attributes = attributes;
        
        GumboVector * cChildren = &gumboNode->v.element.children;
        elementNode.children = [ObjectiveGumbo arrayOfObjectiveGumboNodesFromGumboVector:cChildren andParent:elementNode];
        
        node = elementNode;
    }
    else
    {
        const char * cText = gumboNode->v.text.text;
        NSString * text = [[NSString alloc] initWithUTF8String:cText];
        node = [[OGText alloc] initWithText:text andType:gumboNode->type];
    }
    
    return node;
}

+(NSArray*)arrayOfObjectiveGumboNodesFromGumboVector:(GumboVector*)cChildren andParent:(OGNode*)parent
{
    NSMutableArray * children = [NSMutableArray new];
    
    for (int i = 0; i < cChildren->length; i++)
    {
        OGNode * childNode = [ObjectiveGumbo objectiveGumboNodeFromGumboNode:cChildren->data[i]];
        childNode.parent = parent;
        [children addObject:childNode];
    }
    
    return children;
}

@end
