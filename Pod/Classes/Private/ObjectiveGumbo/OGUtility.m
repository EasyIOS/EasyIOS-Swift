//
//  OGUtility.m
//  Hacker News
//
//  Created by Thomas Denney on 30/08/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "OGUtility.h"

@implementation OGUtility

+(NSString*)tagForGumboTag:(GumboTag)tag
{
    return [OGUtility tagStrings][tag];
}

+(GumboTag)gumboTagForTag:(NSString *)tag
{
    return [[OGUtility tagStrings] indexOfObject:tag];
}

+(NSArray*)tagStrings
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:GUMBO_TAG_LAST];
    //These were generated using a Textmate macro
    //A C equivalent of this exists in tag.c of Gumbo
    array[GUMBO_TAG_HTML] = @"html";
    array[GUMBO_TAG_HEAD] = @"head";
    array[GUMBO_TAG_TITLE] = @"title";
    array[GUMBO_TAG_BASE] = @"base";
    array[GUMBO_TAG_LINK] = @"link";
    array[GUMBO_TAG_META] = @"meta";
    array[GUMBO_TAG_STYLE] = @"style";
	array[GUMBO_TAG_SCRIPT] = @"script";
    array[GUMBO_TAG_NOSCRIPT] = @"noscript";
    array[GUMBO_TAG_BODY] = @"body";
    array[GUMBO_TAG_SECTION] = @"section";
    array[GUMBO_TAG_NAV] = @"nav";
    array[GUMBO_TAG_ARTICLE] = @"article";
    array[GUMBO_TAG_ASIDE] = @"aside";
    array[GUMBO_TAG_H1] = @"h1";
    array[GUMBO_TAG_H2] = @"h2";
    array[GUMBO_TAG_H3] = @"h3";
    array[GUMBO_TAG_H4] = @"h4";
    array[GUMBO_TAG_H5] = @"h5";
    array[GUMBO_TAG_H6] = @"h6";
    array[GUMBO_TAG_HGROUP] = @"hgroup";
    array[GUMBO_TAG_HEADER] = @"header";
    array[GUMBO_TAG_FOOTER] = @"footer";
    array[GUMBO_TAG_ADDRESS] = @"address";
    array[GUMBO_TAG_P] = @"p";
    array[GUMBO_TAG_HR] = @"hr";
    array[GUMBO_TAG_PRE] = @"pre";
    array[GUMBO_TAG_BLOCKQUOTE] = @"blockquote";
    array[GUMBO_TAG_OL] = @"ol";
    array[GUMBO_TAG_UL] = @"ul";
    array[GUMBO_TAG_LI] = @"li";
    array[GUMBO_TAG_DL] = @"dl";
    array[GUMBO_TAG_DT] = @"dt";
    array[GUMBO_TAG_DD] = @"dd";
    array[GUMBO_TAG_FIGURE] = @"figure";
    array[GUMBO_TAG_FIGCAPTION] = @"figcaption";
    array[GUMBO_TAG_DIV] = @"div";
    array[GUMBO_TAG_A] = @"a";
    array[GUMBO_TAG_EM] = @"em";
    array[GUMBO_TAG_STRONG] = @"strong";
    array[GUMBO_TAG_SMALL] = @"small";
    array[GUMBO_TAG_S] = @"s";
    array[GUMBO_TAG_CITE] = @"cite";
    array[GUMBO_TAG_Q] = @"q";
    array[GUMBO_TAG_DFN] = @"dfn";
    array[GUMBO_TAG_ABBR] = @"abbr";
    array[GUMBO_TAG_TIME] = @"time";
    array[GUMBO_TAG_CODE] = @"code";
    array[GUMBO_TAG_VAR] = @"var";
    array[GUMBO_TAG_SAMP] = @"samp";
    array[GUMBO_TAG_KBD] = @"kbd";
    array[GUMBO_TAG_SUB] = @"sub";
    array[GUMBO_TAG_SUP] = @"sup";
    array[GUMBO_TAG_I] = @"i";
    array[GUMBO_TAG_B] = @"b";
    array[GUMBO_TAG_MARK] = @"mark";
    array[GUMBO_TAG_RUBY] = @"ruby";
    array[GUMBO_TAG_RT] = @"rt";
    array[GUMBO_TAG_RP] = @"rp";
    array[GUMBO_TAG_BDI] = @"bdi";
    array[GUMBO_TAG_BDO] = @"bdo";
    array[GUMBO_TAG_SPAN] = @"span";
    array[GUMBO_TAG_BR] = @"br";
    array[GUMBO_TAG_WBR] = @"wbr";
    array[GUMBO_TAG_INS] = @"ins";
    array[GUMBO_TAG_DEL] = @"del";
    array[GUMBO_TAG_IMAGE] = @"image";
    array[GUMBO_TAG_IMG] = @"img";
    array[GUMBO_TAG_IFRAME] = @"iframe";
    array[GUMBO_TAG_EMBED] = @"embed";
    array[GUMBO_TAG_OBJECT] = @"object";
    array[GUMBO_TAG_PARAM] = @"param";
    array[GUMBO_TAG_VIDEO] = @"video";
    array[GUMBO_TAG_AUDIO] = @"audio";
    array[GUMBO_TAG_SOURCE] = @"source";
    array[GUMBO_TAG_TRACK] = @"track";
    array[GUMBO_TAG_CANVAS] = @"canvas";
    array[GUMBO_TAG_MAP] = @"map";
    array[GUMBO_TAG_AREA] = @"area";
    array[GUMBO_TAG_MATH] = @"math";
    array[GUMBO_TAG_MI] = @"mi";
    array[GUMBO_TAG_MO] = @"mo";
    array[GUMBO_TAG_MN] = @"mn";
    array[GUMBO_TAG_MS] = @"ms";
    array[GUMBO_TAG_MTEXT] = @"mtext";
    array[GUMBO_TAG_MGLYPH] = @"mglyph";
    array[GUMBO_TAG_MALIGNMARK] = @"malignmark";
    array[GUMBO_TAG_ANNOTATION_XML] = @"xml";
    array[GUMBO_TAG_SVG] = @"svg";
    array[GUMBO_TAG_FOREIGNOBJECT] = @"foreignobject";
    array[GUMBO_TAG_DESC] = @"desc";
    array[GUMBO_TAG_TABLE] = @"table";
    array[GUMBO_TAG_CAPTION] = @"caption";
    array[GUMBO_TAG_COLGROUP] = @"colgroup";
    array[GUMBO_TAG_COL] = @"col";
    array[GUMBO_TAG_TBODY] = @"tbody";
    array[GUMBO_TAG_THEAD] = @"thead";
    array[GUMBO_TAG_TFOOT] = @"tfoot";
    array[GUMBO_TAG_TR] = @"tr";
    array[GUMBO_TAG_TD] = @"td";
    array[GUMBO_TAG_TH] = @"th";
    array[GUMBO_TAG_FORM] = @"form";
    array[GUMBO_TAG_FIELDSET] = @"fieldset";
    array[GUMBO_TAG_LEGEND] = @"legend";
    array[GUMBO_TAG_LABEL] = @"label";
    array[GUMBO_TAG_INPUT] = @"input";
    array[GUMBO_TAG_BUTTON] = @"button";
    array[GUMBO_TAG_SELECT] = @"select";
    array[GUMBO_TAG_DATALIST] = @"datalist";
    array[GUMBO_TAG_OPTGROUP] = @"optgroup";
    array[GUMBO_TAG_OPTION] = @"option";
    array[GUMBO_TAG_TEXTAREA] = @"textarea";
    array[GUMBO_TAG_KEYGEN] = @"keygen";
    array[GUMBO_TAG_OUTPUT] = @"output";
    array[GUMBO_TAG_PROGRESS] = @"progress";
    array[GUMBO_TAG_METER] = @"meter";
    array[GUMBO_TAG_DETAILS] = @"details";
    array[GUMBO_TAG_SUMMARY] = @"summary";
    array[GUMBO_TAG_COMMAND] = @"command";
    array[GUMBO_TAG_MENU] = @"menu";
    array[GUMBO_TAG_APPLET] = @"applet";
    array[GUMBO_TAG_ACRONYM] = @"acronym";
    array[GUMBO_TAG_BGSOUND] = @"bgsound";
    array[GUMBO_TAG_DIR] = @"dir";
    array[GUMBO_TAG_FRAME] = @"frame";
    array[GUMBO_TAG_FRAMESET] = @"frameset";
    array[GUMBO_TAG_NOFRAMES] = @"noframes";
    array[GUMBO_TAG_ISINDEX] = @"isindex";
    array[GUMBO_TAG_LISTING] = @"listing";
    array[GUMBO_TAG_XMP] = @"xmp";
    array[GUMBO_TAG_NEXTID] = @"nextid";
    array[GUMBO_TAG_NOEMBED] = @"noembed";
    array[GUMBO_TAG_PLAINTEXT] = @"plaintext";
    array[GUMBO_TAG_RB] = @"rb";
    array[GUMBO_TAG_STRIKE] = @"strike";
    array[GUMBO_TAG_BASEFONT] = @"basefont";
    array[GUMBO_TAG_BIG] = @"big";
    array[GUMBO_TAG_BLINK] = @"blink";
    array[GUMBO_TAG_CENTER] = @"center";
    array[GUMBO_TAG_FONT] = @"font";
    array[GUMBO_TAG_MARQUEE] = @"marquee";
    array[GUMBO_TAG_MULTICOL] = @"multicol";
    array[GUMBO_TAG_NOBR] = @"nobr";
    array[GUMBO_TAG_SPACER] = @"spacer";
    array[GUMBO_TAG_TT] = @"tt";
    array[GUMBO_TAG_U] = @"u";
    array[GUMBO_TAG_UNKNOWN] = @"unknown";
    return array;
}

@end
