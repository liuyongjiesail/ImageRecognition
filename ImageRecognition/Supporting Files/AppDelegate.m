//
//  AppDelegate.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/27.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "AppDelegate.h"
#import "XRVendorServiceManager.h"
#import "XRMainViewController.h"
#import "XRRecognitionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [XRVendorServiceManager shared];
    
    [self setRootViewController];
    
    return YES;
}

- (void)setRootViewController {
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    RTRootNavigationController *rootNavigation =  [[RTRootNavigationController alloc] initWithRootViewController:[XRRecognitionViewController new]];
    rootNavigation.useSystemBackBarButtonItem = YES;

    self.window.rootViewController = rootNavigation;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
}

@end
