//
//  XRGDTBannerApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRGDTBannerApi.h"

@interface XRGDTBannerApi () <GDTMobBannerViewDelegate>

@end

@implementation XRGDTBannerApi

- (UIView *)loadBannerAdView:(UIViewController *)viewController {

    GDTMobBannerView *bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, viewController.view.height - 50, SCREEN_WIDTH, 50) appId:XRGDTAppId placementId:XRGDTBannerPlacementId];
    bannerView.currentViewController = viewController;
    bannerView.delegate = self;
    [viewController.view addSubview:bannerView];
    [bannerView loadAdAndShow];
    
    return bannerView;
}

/**
 加载成功
 */
- (void)bannerViewDidReceived {
    
}

/**
 加载失败

 @param error error
 */
- (void)bannerViewFailToReceived:(NSError *)error {
    
}

/**
 关闭
 */
- (void)bannerViewWillClose {
    
}

/**
 曝光回调
 */
- (void)bannerViewWillExposure {
    
}

/**
 点击回调
 */
- (void)bannerViewClicked {
    
}

@end
