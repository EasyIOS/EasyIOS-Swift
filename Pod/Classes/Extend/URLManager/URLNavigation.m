//
//  HKObserver.m
//  Hoko
//
//  Created by Hoko, S.A. on 23/07/14.
//  Copyright (c) 2015 Hoko, S.A. All rights reserved.
//

#import "URLNavigation.h"
@implementation URLNavigation

#pragma mark - Singleton
+ (instancetype)shareInstance{
    static dispatch_once_t predicate = 0;
    static id sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public Method
+ (void)setRootViewController:(UIViewController *)viewController
{
  [URLNavigation shareInstance].applicationDelegate.window.rootViewController = viewController;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [self pushViewController:viewController animated:animated replace:NO];
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace
{
  // Check if viewController is a UINavigationController
  if([viewController isKindOfClass:[UINavigationController class]])
    [URLNavigation setRootViewController:viewController];
  else {
    // Check if a UINavigationController exists in the view controllers stack.
    UINavigationController *navigationController = [URLNavigation shareInstance].currentNavigationViewController;
    if (navigationController) {
      // In case it should replace, look for the last UIViewController on the UINavigationController, if it's of the same class, replace it with a new one.
      if (replace && [navigationController.viewControllers.lastObject isKindOfClass:[viewController class]]) {
        NSArray *viewControllers = [navigationController.viewControllers subarrayWithRange:NSMakeRange(0, navigationController.viewControllers.count-1)];
        [navigationController setViewControllers:[viewControllers arrayByAddingObject:viewController] animated:animated];
      } else {
        // Otherwise just push the new viewController
        [navigationController pushViewController:viewController animated:animated];
      }
    } else {
      // Create a new UINavigationController to use with the viewController
      navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
      [URLNavigation shareInstance].applicationDelegate.window.rootViewController = navigationController;
    }
  }
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  // Look for the currentViewController
  UIViewController *currentViewController = [[URLNavigation shareInstance] currentViewController];
  if (currentViewController) {
    // Present viewController from currentViewcontroller
    [currentViewController presentViewController:viewController animated:animated completion:nil];
  } else {
    // Otherwise set the window rootViewController
    [URLNavigation shareInstance].applicationDelegate.window.rootViewController = viewController;
  }
}


+(void)dismissCurrentAnimated:(BOOL)animated{
  UIViewController *currentViewController = [[URLNavigation shareInstance] currentViewController];
  if(currentViewController){
      if(currentViewController.navigationController){
          if(currentViewController.navigationController.viewControllers.count == 1){
              if(currentViewController.presentingViewController){
                  [currentViewController dismissViewControllerAnimated:animated completion:nil];
              }
          }else{
              [currentViewController.navigationController popViewControllerAnimated:animated];
          }
      }else if(currentViewController.presentingViewController){
          [currentViewController dismissViewControllerAnimated:animated completion:nil];
      }
  }
}

#pragma mark - Private Methods
- (id<UIApplicationDelegate>)applicationDelegate
{
  return [UIApplication sharedApplication].delegate;
}

+(UIViewController*)currentViewController{
    return [[URLNavigation shareInstance] currentViewController];
}

- (UIViewController*)currentViewController
{
  UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
  return [self currentViewControllerFrom:rootViewController];
}

+(UIViewController*)currentNavigationViewController{
    return [[URLNavigation shareInstance] currentNavigationViewController];
}

- (UINavigationController*)currentNavigationViewController
{
  UIViewController* currentViewController = self.currentViewController;
  return currentViewController.navigationController;
}

- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController
{
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navigationController = (UINavigationController *)viewController;
    return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
  } else if([viewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController* tabBarController = (UITabBarController *)viewController;
    return [self currentViewControllerFrom:tabBarController.selectedViewController];
  } else if(viewController.presentedViewController != nil) {
    return [self currentViewControllerFrom:viewController.presentedViewController];
  } else {
    return viewController;
  }
}

@end
