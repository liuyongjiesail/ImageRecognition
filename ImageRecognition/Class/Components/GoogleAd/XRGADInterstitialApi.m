//
//  XRGADInterstitialApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/19.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRGADInterstitialApi.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface XRGADInterstitialApi ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;
@property (copy, nonatomic) void(^tempSuccess)(void);

@end

@implementation XRGADInterstitialApi

+ (instancetype)shared {
    static XRGADInterstitialApi *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XRGADInterstitialApi new];
    });
    return manager;
}

- (void)showInterstitialViewController:(UIViewController *)viewController {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:viewController];
    } else {
        XRLog(@"Ad wasn't ready");
    }
}

- (void)requestInterstitialSuccess:(void(^)(void))success {
    self.tempSuccess = success;
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:XRGoogleInterstitialUnitId];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest new];
#ifdef DEBUG
    request.testDevices = @[@"dd49d1cae00d5e50a0a37e679291c784"];
#else
#endif
    [self.interstitial loadRequest:request];
}

#pragma mark - GADInterstitialDelegate
/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    XRLog(@"interstitialDidReceiveAd");
    if (self.tempSuccess) {
        self.tempSuccess();
    }
    [TalkingData trackEvent:@"interstitialDidReceiveAd"];
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    XRLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    XRLog(@"interstitialWillPresentScreen");
    [self requestInterstitialSuccess:nil];
    [TalkingData trackEvent:@"interstitialWillPresentScreen"];
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    XRLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    XRLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    XRLog(@"interstitialWillLeaveApplication");
}

@end
