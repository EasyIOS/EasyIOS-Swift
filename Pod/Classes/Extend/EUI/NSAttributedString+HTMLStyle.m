//
//  NSAttributedString+HTMLStyle.m
//  QRContentMobilizer
//
//  Created by Wojciech Czekalski on 22.03.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import "NSAttributedString+HTMLStyle.h"
#import "regex.h"
#import <UIKit/UIKit.h>

QRHTMLAttribute * const QRHTMLAttributeParagraph = @"p";
QRHTMLAttribute * const QRHTMLAttributeLink = @"a";
QRHTMLAttribute * const QRHTMLAttributeHeader1 = @"h1";
QRHTMLAttribute * const QRHTMLAttributeHeader2 = @"h2";
QRHTMLAttribute * const QRHTMLAttributeHeader3 = @"h3";
QRHTMLAttribute * const QRHTMLAttributeHeader4 = @"h4";
QRHTMLAttribute * const QRHTMLAttributeHeader5 = @"h5";
QRHTMLAttribute * const QRHTMLAttributeHeader6 = @"h6";
QRHTMLAttribute * const QRHTMLAttributeEmphasis = @"em";
QRHTMLAttribute * const QRHTMLAttributeStrong = @"strong";
QRHTMLAttribute * const QRHTMLAttributeBold = @"b";
QRHTMLAttribute * const QRHTMLAttributeAlternateVoice = @"i";
QRHTMLAttribute * const QRHTMLAttributeSmall = @"small";
QRHTMLAttribute * const QRHTMLAttributeSubscripted = @"sub";
QRHTMLAttribute * const QRHTMLAttributeSuperscripted = @"sup";
QRHTMLAttribute * const QRHTMLAttributeInserted = @"ins";
QRHTMLAttribute * const QRHTMLAttributeDeleted = @"del";
QRHTMLAttribute * const QRHTMLAttributeHighlighted = @"mark";
QRHTMLAttribute * const QRHTMLAttributeCode = @"code";
QRHTMLAttribute * const QRHTMLAttributeKeyboardText = @"kbd";
QRHTMLAttribute * const QRHTMLAttributeSampleCode = @"samp";
QRHTMLAttribute * const QRHTMLAttributeVariable = @"var";
QRHTMLAttribute * const QRHTMLAttributePreformatted = @"pre";
QRHTMLAttribute * const QRHTMLAttributeAbbreviation = @"abbr";
QRHTMLAttribute * const QRHTMLAttributeAddress = @"address";
QRHTMLAttribute * const QRHTMLAttributeBlockQuote = @"blockquote";
QRHTMLAttribute * const QRHTMLAttributeInlineQuote = @"q";
QRHTMLAttribute * const QRHTMLAttributeTitle = @"cite";
QRHTMLAttribute * const QRHTMLAttributeDefinition = @"dfn";

@implementation NSAttributedString (HTMLStyle)

+ (instancetype)attributedStringFromHTMLFileAtURL:(NSURL *)html CSSURL:(NSURL *)css {
    return [self attributedStringFromHTMLData:[NSData dataWithContentsOfURL:html] CSSData:[NSData dataWithContentsOfURL:css]];
}

+ (instancetype)attributedStringFromHTMLString:(NSString *)html CSSString:(NSString *)css {
    return [self attributedStringFromHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding] CSSData:[css dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (instancetype)attributedStringFromHTMLData:(NSData *)data {
    return [[self alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:NULL error:nil];
}

+ (instancetype)attributedStringFromHTMLData:(NSData *)html CSSData:(NSData *)css {
    if (css) {
        NSMutableData *newHTMLData = [css mutableCopy];
        [newHTMLData appendData:html];
        return [self attributedStringFromHTMLData:newHTMLData];
    }
    return [self attributedStringFromHTMLData:html];
}

+ (instancetype)attributedStringFromHTMLData:(NSData *)data attributes:(NSDictionary *)attributes {
    return [self attributedStringFromHTMLData:data CSSData:[[attributes CSSStringFromAttributes] dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

@interface UIColor (HTMLRGBString)
- (NSString *)HTMLRGBString;
@end

@implementation UIColor (HTMLRGBString)

- (NSString *)HTMLRGBString {
    UIColor *color = self;
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    if (CGColorGetNumberOfComponents(color.CGColor) == 2) {
        CGFloat white = 0.f, alpha = 0.f;
        [color getWhite:&white alpha:&alpha];
        red = white;
        green = white;
        blue = white;
    } else {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
    return [NSString stringWithFormat:@"rgb(%li, %li, %li)", lroundf(red*255.f), lroundf(green*255.f), lroundf(blue*255.f)];
}

@end

@implementation NSDictionary (CSS)

+ (NSString *)cssStringWithValues:(NSDictionary *)attributes HTMLTag:(QRHTMLAttribute *)tag {
    
    NSMutableString *cssString = [NSMutableString stringWithFormat:@"%@ {", tag];
    
    for (NSString *key in attributes) {
        
#if DEBUG
        NSSet *set = [NSSet setWithObjects:NSLigatureAttributeName, NSKernAttributeName, NSStrikethroughStyleAttributeName, NSStrikethroughColorAttributeName, NSUnderlineStyleAttributeName, NSStrokeColorAttributeName, NSStrokeWidthAttributeName, NSTextEffectAttributeName, NSObliquenessAttributeName, NSExpansionAttributeName, NSWritingDirectionAttributeName, NSVerticalGlyphFormAttributeName, NSUnderlineColorAttributeName, NSAttachmentAttributeName, NSLinkAttributeName, NSBaselineOffsetAttributeName, nil];
        NSAssert(![set containsObject:key], @"Invalid Key. This library doesn't support %@ yet.", key);
#endif

        
        if (key == NSFontAttributeName) {
            UIFont *font = attributes[NSFontAttributeName];
            [cssString appendFormat:@"font-family:'%@'; font-size: %0.fpx; ", font.fontName, roundf(font.pointSize)];;
        } else if (key == NSParagraphStyleAttributeName) {
            NSParagraphStyle *style = attributes[key];
            
            NSString *alignment;
            
            switch (style.alignment) {
                case NSTextAlignmentCenter:
                    alignment = @"center";
                    break;
                case NSTextAlignmentJustified:
                    alignment = @"justify";
                    break;
                case NSTextAlignmentLeft:
                    alignment = @"left";
                    break;
                case NSTextAlignmentNatural:
                    alignment = @"initial";
                    break;
                case NSTextAlignmentRight:
                    alignment = @"right";
                    break;
                default:
                    alignment = @"left";
                    break;
            }
            
            [cssString appendFormat:@"line-height:%0.1f%%; text-align:%@;", style.lineHeightMultiple*100, alignment];
            if (style.baseWritingDirection == NSWritingDirectionRightToLeft){
                [cssString appendString:@"direction:rtl;"];
            }else{
                [cssString appendString:@"direction:ltr;"];
            }
            
            
        } else if (key == NSForegroundColorAttributeName) {
            [cssString appendFormat:@"color:%@; ", [attributes[key] HTMLRGBString]];
        } else if (key == NSBackgroundColorAttributeName ) {
            [cssString appendFormat:@"background-color:%@; ", [attributes[key] HTMLRGBString]];;
        } else if (key == NSShadowAttributeName) {
            NSShadow *shadow = attributes[NSShadowAttributeName];
            [cssString appendFormat:@"text-shadow: %fpx %fpx %fpx %@; ", shadow.shadowOffset.width, shadow.shadowOffset.height, shadow.shadowBlurRadius, [shadow.shadowColor HTMLRGBString]];
        }
    }
    
    [cssString appendString:@"}"];
    
    return cssString;
}

- (NSString *)CSSStringFromAttributes {
    NSMutableString *string = [NSMutableString stringWithString:@"<style>"];
    
    for (NSString *key in self) {
        id object = self[key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            [string appendString:[NSDictionary cssStringWithValues:object HTMLTag:key]];
        } else if ([object isKindOfClass:[NSString class]]) {
            [string appendString:object];
        }
    }
    
    [string appendString:@"</style>"];
    
    return string;
}

@end

@implementation NSMutableDictionary (CSS)

- (void)addAttributes:(NSDictionary *)attributes forHTMLAttribute:(QRHTMLAttribute *)tag flatten:(BOOL)flatten {
    if (!flatten) {
        [self setObject:attributes forKey:tag];
    } else {
        [self setObject:[NSDictionary cssStringWithValues:attributes HTMLTag:tag] forKey:tag];
    }
}

@end

@implementation NSData (HTMLAdditions)

- (NSData *)dataByReplacingOccurrencesOfData:(NSData *)data withData:(NSData *)replacementData {
    NSMutableData *mutableSelf = [self mutableCopy];
    const void *replacementBytes = [replacementData bytes];
    NSUInteger replacementBytesLength = [replacementData length];
    
    NSRange rangeOfCharacters = [mutableSelf rangeOfData:data options:0 range:NSMakeRange(0, [mutableSelf length])];
    
    while (rangeOfCharacters.location != NSNotFound) {
        [mutableSelf replaceBytesInRange:rangeOfCharacters withBytes:replacementBytes];
        NSUInteger searchLocation = replacementBytesLength + rangeOfCharacters.location;
        rangeOfCharacters = [mutableSelf rangeOfData:data options:0 range:NSMakeRange(searchLocation, [mutableSelf length]-searchLocation)];
    }
    
    return [NSData dataWithData:mutableSelf];
}

@end