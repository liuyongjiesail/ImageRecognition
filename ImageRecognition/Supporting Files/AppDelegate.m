//
//  AppDelegate.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/27.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "AppDelegate.h"
#import "XRVendorServiceManager.h"
#import "XRRecognitionViewController.h"
#import "MXNavigationController.h"

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
    
    MXNavigationController *rootNavigation =  [[MXNavigationController alloc] initWithRootViewController:[XRRecognitionViewController new]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    self.window.rootViewController = rootNavigation;
    [self.window makeKeyAndVisible];
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isAllowRotation) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotate {
    return self.isAllowRotation;
}

@end
