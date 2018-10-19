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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self requestInterstitial];
    }
    return self;
}

- (void)showInterstitialViewController:(UIViewController *)viewController {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:viewController];
    } else {
        XRLog(@"Ad wasn't ready");
        [self requestInterstitial];
    }
}

- (void)requestInterstitial {
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
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    XRLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    XRLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    XRLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    XRLog(@"interstitialDidDismissScreen");
    [self requestInterstitial];
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    XRLog(@"interstitialWillLeaveApplication");
}

@end
