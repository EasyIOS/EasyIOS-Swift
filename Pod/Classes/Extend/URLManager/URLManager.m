//
//  URLManager.m
//  rssreader
//
//  Created by zhuchao on 15/3/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager
+ (URLManager *)shareInstance{
    static dispatch_once_t predicate = 0;
    static id sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void)loadConfigFromPlist:(NSString *)plistPath{
    [URLManager shareInstance].config = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURL:(NSURL *)url animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:YES replace:replace];
}

+ (void)pushURL:(NSURL *)url animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated replace:replace];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager shareInstance].config];
    [URLNavigation presentViewController:viewController animated:animated];
}

+ (void)presentURL:(NSURL *)url animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager shareInstance].config];
    [URLNavigation presentViewController:viewController animated:animated];
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[URLManager shareInstance].config];
    [URLNavigation presentViewController:viewController animated:animated];
}

+ (void)presentURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromURL:url withQuery:query fromConfig:[URLManager shareInstance].config];
    [URLNavigation presentViewController:viewController animated:animated];
}

+ (void)pushURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromURL:url withQuery:query fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromURL:url withQuery:query fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated replace:replace];
}

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[URLManager shareInstance].config];
    [URLNavigation pushViewController:viewController animated:animated replace:replace];
}

+ (void)presentURL:(NSURL *)url animated:(BOOL)animated withNavigationClass:(Class)clazz{
    UIViewController *viewController = [UIViewController initFromURL:url fromConfig:[URLManager shareInstance].config];
    UINavigationController *nav =  [[clazz alloc]initWithRootViewController:viewController];
    [URLNavigation presentViewController:nav animated:animated];
}

+ (void)presentURL:(NSURL *)url query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz{
    UIViewController *viewController = [UIViewController initFromURL:url withQuery:query fromConfig:[URLManager shareInstance].config];
    UINavigationController *nav =  [[clazz alloc]initWithRootViewController:viewController];
    [URLNavigation presentViewController:nav animated:animated];
}

+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)clazz{
    
    UIViewController *viewController = [UIViewController initFromString:urlString fromConfig:[URLManager shareInstance].config];
    if ([clazz isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[clazz alloc]initWithRootViewController:viewController];
        [URLNavigation presentViewController:nav animated:animated];
    }
}

+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)clazz{
    UIViewController *viewController = [UIViewController initFromString:urlString withQuery:query fromConfig:[URLManager shareInstance].config];
    if ([clazz isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[clazz alloc]initWithRootViewController:viewController];
        [URLNavigation presentViewController:nav animated:animated];
    }
}
@end