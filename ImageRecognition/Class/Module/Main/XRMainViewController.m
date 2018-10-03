//
//  XRMainViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/27.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRMainViewController.h"
#import "XRHomeViewController.h"

@interface XRMainViewController ()

@end

@implementation XRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllers];
    
}

- (void)addChildViewControllers {
    
    [self addChildViewController:[self navigationController:[XRHomeViewController new] title:@"首页" normalImage:@"" selectedImage:@""]];
    
}

- (UINavigationController *)navigationController:(UIViewController *)viewController title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    
    viewController.title = title;
    
    //设置图标
    viewController.tabBarItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    if (@available(iOS 11.0, *)) {
        navigationController.navigationBar.prefersLargeTitles = YES;
    }
    
    return navigationController;
    
}

@end
