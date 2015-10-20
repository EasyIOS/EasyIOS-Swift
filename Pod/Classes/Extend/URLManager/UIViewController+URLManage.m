//
//  UIViewController+URLManage.m
//  rssreader
//
//  Created by zhuchao on 15/2/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "UIViewController+URLManage.h"
#import <objc/runtime.h>

static char URLoriginUrl;
static char URLpath;
static char URLparams;
static char URLdictQuery;


@implementation UIViewController (URLManage)
-(void)setOriginUrl:(NSURL *)originUrl{
    [self willChangeValueForKey:@"originUrl"];
    objc_setAssociatedObject(self, &URLoriginUrl,
                             originUrl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"originUrl"];
}
-(NSURL *)originUrl {
    return objc_getAssociatedObject(self, &URLoriginUrl);
}

-(NSString *)path {
    return objc_getAssociatedObject(self, &URLpath);
}
-(void)setPath:(NSURL *)path{
    [self willChangeValueForKey:@"path"];
    objc_setAssociatedObject(self, &URLpath,
                             path,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"path"];
}


-(NSDictionary *)params {
    return objc_getAssociatedObject(self, &URLparams);
}
-(void)setParams:(NSDictionary *)params{
    [self willChangeValueForKey:@"params"];
    objc_setAssociatedObject(self, &URLparams,
                             params,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"params"];
}

-(NSDictionary *)dictQuery {
    return objc_getAssociatedObject(self, &URLdictQuery);
}

-(void)setDictQuery:(NSDictionary *)dictQuery{
    [self willChangeValueForKey:@"dictQuery"];
    objc_setAssociatedObject(self, &URLdictQuery,
                             dictQuery,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"dictQuery"];
}

-(void)open:(NSURL *)url withQuery:(NSDictionary *)dict{
    self.path = [url path];
    self.originUrl = url;
    self.dictQuery = dict;
    
    NSArray *components = [[url query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    self.params = parameters;
}

+ (UIViewController *)initFromString:(NSString *)aString fromConfig:(NSDictionary *)config{
    return [UIViewController initFromURL:[NSURL URLWithString:aString] withQuery:nil fromConfig:config];
}

+ (UIViewController *)initFromURL:(NSURL *)url fromConfig:(NSDictionary *)config{
    return [UIViewController initFromURL:url withQuery:nil fromConfig:config];
}

+ (UIViewController *)initFromString:(NSString *)aString withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)config{
    return [UIViewController initFromURL:[NSURL URLWithString:aString] withQuery:query fromConfig:config] ;
}

+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query fromConfig:(NSDictionary *)config
{
    UIViewController* scene = nil;
    NSString *home;
    if(url.path ==nil){
        home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    }else{
        home = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host,url.path];
    }
    if([config.allKeys containsObject:url.scheme]){
        id cgf = [config objectForKey:url.scheme];
        Class class = nil;
        if([cgf isKindOfClass:[NSString class]]){
            
            class =  [NSObject classFromString:cgf];
        }else if([cgf isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)cgf;
            if([dict.allKeys containsObject:home]){
                class =  [NSObject classFromString:[dict objectForKey:home]];
            }else{
                class =  [NSObject classFromString:url.host];
            }
        }
        if(class !=nil){
            scene = [[class alloc]init];
            if([scene  respondsToSelector:@selector(open:withQuery:)]){
                [scene open:url withQuery:query];
            }
        }
    }else if([query objectForKey:@"openURL"] || [url.scheme hasPrefix:@"http"]){
        [[UIApplication sharedApplication] openURL:url];
    }
    return scene;
}


@end

@implementation NSObject (URLManage)
+ (Class)classFromString:(NSString *)className {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *classStringName = [NSString stringWithFormat:@"%@.%@",appName, className];
    return NSClassFromString(classStringName);
}
+ (NSObject *)objectFromString:(NSString *)className{
    Class clazz = [NSObject classFromString:className];
    return [[clazz alloc]init];
}
@end
