//
//  XRGDTBannerApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRGADBannerApi.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface XRGADBannerApi () <GADBannerViewDelegate>

@end

@implementation XRGADBannerApi

- (UIView *)loadBannerAdView:(UIViewController *)viewController {

    GADAdSize customSize;
    customSize.size.width = SCREEN_WIDTH;
    customSize.size.height = kGADAdSizeBanner.size.height;
    
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:customSize origin:CGPointMake(0, viewController.view.height - customSize.size.height)];
    bannerView.adUnitID = XRGoogleBannerUnitId;
    bannerView.delegate = self;
    bannerView.rootViewController = viewController;
    [viewController.view addSubview:bannerView];
    
    GADRequest *request = [GADRequest new];
    request.testDevices = @[@"dd49d1cae00d5e50a0a37e679291c784"];
    [bannerView loadRequest:request];
    
    return bannerView;
}

#pragma mark - GADBannerViewDelegate

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    XRLog(@"adViewDidReceiveAd");
    [TalkingData trackEvent:@"adViewDidReceiveAd"];
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    XRLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    [TalkingData trackEvent:@"didFailToReceiveAdWithError"];

}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    XRLog(@"adViewWillPresentScreen");
    [TalkingData trackEvent:@"adViewWillPresentScreen"];
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    XRLog(@"adViewWillDismissScreen");
    [TalkingData trackEvent:@"adViewWillDismissScreen"];

}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    XRLog(@"adViewDidDismissScreen");
    [TalkingData trackEvent:@"adViewDidDismissScreen"];
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    XRLog(@"adViewWillLeaveApplication");
    [TalkingData trackEvent:@"adViewWillLeaveApplication"];
}

@end
