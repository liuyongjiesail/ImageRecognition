//
//  XRGADRewardVideoApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/5/13.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import "XRGADRewardVideoApi.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface XRGADRewardVideoApi ()<GADRewardedAdDelegate>

@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property (copy, nonatomic) void(^tempCompletion)(void);

@property(nonatomic, assign) BOOL isRewarded;

@end

@implementation XRGADRewardVideoApi

+ (instancetype)shared {
    static XRGADRewardVideoApi *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XRGADRewardVideoApi new];
    });
    return manager;
}

- (void)removeAds {
    [ApplePayComponent.sharedInstance purchase:@"com.sail.xrecognition.release.18" success:^{
        
        [MBProgressHUD showSuccess:@"您已成功移除强制性广告"];
        [KeychainService setItem:@"YES" forKey:@"VIP"];
        
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD showError:error];
    }];
}

- (void)perloadAd {

    self.rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:XRGoogleRewardVideoUnitId];
    self.isRewarded = NO;
    
    GADRequest *request = [GADRequest request];
    [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
      if (error) {
        // Handle ad failed to load case.
      } else {
        // Ad successfully loaded.
      }
        XRLog(@"%@", error);
    }];
}

- (void)showCompletion:(void(^)(void))completion {
    self.tempCompletion = completion;
    
    if ([[KeychainService itemForKey:@"VIP"] isEqualToString:@"YES"]) {
        if (completion) {
            completion();
        }
        return;
    }
    
    if (self.rewardedAd.isReady) {
      [self.rewardedAd presentFromRootViewController:UIViewController.currentViewController delegate:self];
    } else {
        [self perloadAd];
    }
}

#pragma mark - GADRewardedAdDelegate

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
  // TODO: Reward the user.
    XRLog(@"rewardedAd:userDidEarnReward:");
    self.isRewarded = YES;
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    XRLog(@"rewardedAdDidPresent:");
    [TalkingData trackEvent:@"rewardedAdDidPresent"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"只有当前广告播放完成后\n才会继续下一步操作" icon:@"" time:7];
    });
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    XRLog(@"rewardedAd:didFailToPresentWithError");
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    XRLog(@"rewardedAdDidDismiss:");
    if (self.isRewarded && self.tempCompletion) {
        self.tempCompletion();
    }
    [self perloadAd];
}

@end
