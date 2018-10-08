//
//  RewardedVideoApi.m
//  GoogleAd
//
//  Created by 刘永杰 on  2018/10/3.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "XRGoogleRewardVideoApi.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

static NSString *const GoogleRewardAdLoadSuccess   = @"GoogleRewardAdLoadSuccess";
static NSString *const GoogleRewardAdLoadFailed    = @"GoogleRewardAdLoadFailed";
static NSString *const GoogleRewardAdShowSuccess   = @"GoogleRewardAdShowSuccess";
static NSString *const GoogleRewardAdShowFailed    = @"GoogleRewardAdShowFailed";
static NSString *const GoogleRewardAdClicked       = @"GoogleRewardAdClicked";
static NSString *const GoogleRewardAdRewardSuccess = @"GoogleRewardAdRewardSuccess";

@interface XRGoogleRewardVideoApi () <GADRewardBasedVideoAdDelegate>

@property (copy, nonatomic) NSString *userid;

@end

@implementation XRGoogleRewardVideoApi

+ (instancetype)sharedReward
{
    static dispatch_once_t onceToken;
    static XRGoogleRewardVideoApi *manager;
    dispatch_once(&onceToken, ^{
        manager = [XRGoogleRewardVideoApi new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [GADMobileAds configureWithApplicationID:XRGoogleAdMobAppId];
        [self requestRewardedVideo];
    }
    return self;
}

//请求视频广告
- (void)requestRewardedVideo {
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
                                               withAdUnitID:XRGoogleRewardVideoAdUnitID];
    });

}

//打开视频广告
- (void)showRewardedVideoForViewController:(UIViewController *)viewController
{
    //展示广告之前检查视频广告是否已经下载成功
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:viewController];
    } else {
        [self requestRewardedVideo];
    }
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    XRLog(@"Reward based video ad is received.");
    [TalkingData trackEvent:GoogleRewardAdLoadSuccess];
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    XRLog(@"Opened reward based video ad.");
    [TalkingData trackEvent:GoogleRewardAdShowSuccess];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    XRLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    XRLog(@"Reward based video ad has completed.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    XRLog(@"Reward based video ad is closed.");
    [self requestRewardedVideo];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    XRLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    XRLog(@"Reward based video ad failed to load.");
    [TalkingData trackEvent:GoogleRewardAdLoadFailed];

}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    
    [TalkingData trackEvent:GoogleRewardAdRewardSuccess];

    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
     reward.type,
     [reward.amount doubleValue]];
    XRLog(@"%@", rewardMessage);
}

@end
