//
//  OGDocument.m
//  ObjectiveGumbo
//
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "OGDocument.h"

@implementation OGDocument

-(id)init
{
    self = [super init];
    if (self)
    {
        self.publicIdentifier = @"";
        self.systemIdentifier = @"";
        self.name = @"";
    }
    return self;
}

@end
