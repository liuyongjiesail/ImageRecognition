//
//  MXNavigationController.m
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/10/28.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import "MXNavigationController.h"
#import <WebKit/WebKit.h>

@interface MXNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.useSystemBackBarButtonItem = YES;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX(0x000000),NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        self.backButton = [self createBackButton];
        self.closeButton = [self createCloseButton];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
        
        if ([viewController isKindOfClass:NSClassFromString(@"MVWebViewController")]) {
            viewController.navigationItem.leftBarButtonItems = @[backButtonItem,closeButtonItem];
        } else {
            viewController.navigationItem.leftBarButtonItem = backButtonItem;
        }
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didClickBackButtonEvent {
    UIViewController *vc = self.rt_viewControllers.lastObject;
    if ([vc respondsToSelector:@selector(didClickBackButtonEvent)]) {
        [vc performSelector:@selector(didClickBackButtonEvent)];
        return;
    }
    [self popViewControllerAnimated:YES];
}

- (void)didClickCloseButtonEvent {
    [self popViewControllerAnimated:YES];
}

- (void)setEnableRightGesture:(BOOL)enableRightGesture {
    _enableRightGesture = enableRightGesture;
    
    self.rt_navigationController.topViewController.fd_interactivePopDisabled = !enableRightGesture;
}

#pragma mark - Lazy Loading

- (UIButton *)createBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 33, 44);
    [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [backButton addTarget:self action:@selector(didClickBackButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UIButton *)createCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 33, 44);
    [closeButton setImage:[UIImage imageNamed:@"navigation_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(didClickCloseButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}

//获取侧滑返回手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

@end
