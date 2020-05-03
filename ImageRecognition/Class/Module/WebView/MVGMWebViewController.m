//
//  MVGMWebViewController.m
//  MetaAppVideo
//
//  Created by 刘永杰 on 2020/3/4.
//  Copyright © 2020 MetaApp. All rights reserved.
//

#import "MVGMWebViewController.h"
#import "MVShandwApi.h"
#import "MVGMExitFloat.h"
#import "MXNavigationController.h"
#import "AppDelegate.h"

@interface MVGMWebViewController ()

@property (assign, nonatomic) BOOL isLandscape;

@property (strong, nonatomic) XRItemModel *gameModel;

@end

@implementation MVGMWebViewController

+ (void)showGM:(XRItemModel *)model {
    MVGMWebViewController *gmWeb = [MVGMWebViewController new];
    gmWeb.gameModel = model;
    if (model.type == MXItemTypeGameLinks) {
        gmWeb.webURL = [NSURL URLWithString:model.itemUrl];
    } else if (model.type == MXItemTypeGameShandw) {
        gmWeb.webURL = [NSURL URLWithString:[MVShandwApi generateUrlGmId:model.itemId]];
    }
    gmWeb.isLandscape = model.isLandscape;
    [[UIViewController currentViewController] showViewController:gmWeb sender:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.rt_navigationController.rt_viewControllers.lastObject isKindOfClass:MVGMWebViewController.class]) {
        return;
    }
    //暂时这么解决，后续修改
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isLandscape = NO;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.navigationController.navigationBar.hidden = YES;
    [(MXNavigationController *)self.navigationController setEnableRightGesture:NO];
    
    self.webView.height = SCREEN_HEIGHT;
    
    [MVGMExitFloat.shareInstance showInView:self.webView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:MVGMExitFloat.shareInstance action:@selector(superViewTapAction)];
    tap.delegate = self;
    [self.webView addGestureRecognizer:tap];
        
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
}

- (void)setIsLandscape:(BOOL)isLandscape {
    _isLandscape = isLandscape;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = isLandscape;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:isLandscape ? UIDeviceOrientationLandscapeLeft : UIInterfaceOrientationMaskPortrait] forKey:@"orientation"];
}

- (BOOL)showAds {
    return NO;
}

- (BOOL)showProgress {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSInteger)delayTime {
    return self.gameModel.delayTime == 0 ? 45 : self.gameModel.delayTime;
}

@end
