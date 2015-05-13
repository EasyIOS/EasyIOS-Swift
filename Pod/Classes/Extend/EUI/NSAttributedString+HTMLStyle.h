//
//  NSAttributedString+HTMLStyle.h
//  QRContentMobilizer
//
//  Created by Wojciech Czekalski on 22.03.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString QRHTMLAttribute;

FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeParagraph;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeLink;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHeader1;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHeader2;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHeader3;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHeader4;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHeader5;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHeader6;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeEmphasis;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeStrong;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeBold;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeAlternateVoice;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeSmall;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeSubscripted;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeSuperscripted;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeInserted;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeDeleted;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeHighlighted;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeCode;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeKeyboardText;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeSampleCode;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeVariable;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributePreformatted;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeAbbreviation;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeAddress;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeBlockQuote;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeInlineQuote;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeTitle;
FOUNDATION_EXPORT QRHTMLAttribute * const QRHTMLAttributeDefinition;

/**
 *  Creation of NSAttributedString out of HTML with per-tag attributes made easy.
 */

@interface NSAttributedString (HTMLStyle)
/**
 *  Creates an attributed string from HTML data. Assumes `NSUTF8StringEncoding`.
 *
 *  @param data Data to be processed.
 *
 *  @return Returns a new instance of `NSAttributedString` or nil if given data was invalid.
 */
+ (instancetype)attributedStringFromHTMLData:(NSData *)data;

/**
 *  Creates an attributed string from HTML string and CSS string with attributes.
 *
 *  @param html A string containing HTML.
 *  @param css  A CSS string. If nil, use attributedStringFromHTMLData: instead.
 *
 *  @abstract Don't convert your HTML and CSS into NSStrings from NSData objects. Use `attributedStringFromHTMLData:CSSData:` instead.
 *
 *  @return Returns a new instance of `NSAttributedString` or nil if given data was invalid.
 */

+ (instancetype)attributedStringFromHTMLString:(NSString *)html CSSString:(NSString *)css;

/**
 *  Creates an attributed string from merged HTML and CSS data.
 *
 *  @param html HTML data to be processed
 *  @param css  CSS data to be processed
 *
 *  @return Returns a new instance of NSAttributedString or nil if given data was invalid.
 */

+ (instancetype)attributedStringFromHTMLData:(NSData *)html CSSData:(NSData *)css;

/**
 *  Creates an attributed string from merged HTML and CSS files.
 *
 *  @param html URL of a CSS file.
 *  @param css  URL of a CSS file.
 *
 *  @return Returns a new instance of NSAttributedString or nil if given data was invalid.
 */

+ (instancetype)attributedStringFromHTMLFileAtURL:(NSURL *)html CSSURL:(NSURL *)css;

/**
 *  Creates an attributed string from HTML data and attributes parsed from attributes dict.
 *
 *  @param data       HTML data to be processed
 *  @param attributes Key-Value pairs of NSAttributedString attributes keyed under HTML tags.
 *
 *  @return Returns a new instance of NSAttributedString or nil if given data was invalid.
 */

+ (instancetype)attributedStringFromHTMLData:(NSData *)data attributes:(NSDictionary *)attributes;
@end

/**
 *  Convinience methods for dealing with adding attributes to `NSAttributedStrings` from HTML.
 */

@interface NSMutableDictionary (CSS)

/**
 *  Sets attributes for a given HTML tag.
 *
 *  @param attributes NSDictionary containing key-value pairs of `NSAttributedString` attributes.
 *  @param tag        `HTML` tag to be assigned to the attributes
 *  @param flatten    if flatten set to yes, the dictionary is converted into CSS string before being added to the receiver.
 */

- (void)addAttributes:(NSDictionary *)attributes forHTMLAttribute:(QRHTMLAttribute *)tag flatten:(BOOL)flatten;

@end

@interface NSDictionary (CSS)

/**
 *  Parses receiver and creates a `NSString` with `CSS` attributes.
 *
 *  @return Returns a `NSString` with `CSS` attributes.
 */

- (NSString *)CSSStringFromAttributes;

@end

/**
 *  NSData category which adds method allowing to replace occurencies of given data with another data.
 */

@interface NSData (HTMLAdditions)

/**
 *  Creates `NSData` instance with replaced occurencies.
 *
 *  @param data            `NSData` to be replaced.
 *  @param replacementData `NSData` to be inserted in place of `data`.
 *
 *  This method replaces all occurencies of `data` with `replacementData`.
 *
 *  @return Returns `NSData` with replaced contents.
 */

- (NSData *)dataByReplacingOccurrencesOfData:(NSData *)data withData:(NSData *)replacementData;
@end