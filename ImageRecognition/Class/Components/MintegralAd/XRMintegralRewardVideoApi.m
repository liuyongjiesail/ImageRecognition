//
//  RewardedVideoApi.m
//  GoogleAd
//
//  Created by 刘永杰 on  2018/10/3.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "XRMintegralRewardVideoApi.h"
#import <MTGSDKReward/MTGRewardAdManager.h>
#import <MTGSDK/MTGSDK.h>

static NSString *const MintegralRewardAdLoadSuccess   = @"MintegralRewardAdLoadSuccess";
static NSString *const MintegralRewardAdLoadFailed    = @"MintegralRewardAdLoadFailed";
static NSString *const MintegralRewardAdShowSuccess   = @"MintegralRewardAdShowSuccess";
static NSString *const MintegralRewardAdShowFailed    = @"MintegralRewardAdShowFailed";
static NSString *const MintegralRewardAdClicked       = @"MintegralRewardAdClicked";
static NSString *const MintegralRewardAdRewardSuccess = @"MintegralRewardAdRewardSuccess";

@interface XRMintegralRewardVideoApi () <MTGRewardAdLoadDelegate, MTGRewardAdShowDelegate>

@end

@implementation XRMintegralRewardVideoApi

+ (instancetype)sharedReward
{
    static dispatch_once_t onceToken;
    static XRMintegralRewardVideoApi *manager;
    dispatch_once(&onceToken, ^{
        manager = [XRMintegralRewardVideoApi new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MTGSDK.sharedInstance setAppID:XRMintegralAppId ApiKey:XRMintegralAppkey];
        [self requestRewardedVideo];
    }
    return self;
}

//请求视频广告
- (void)requestRewardedVideo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [MTGRewardAdManager.sharedInstance loadVideo:XRMintegralAdUnitId delegate:self];
    });
}

//打开视频广告
- (void)showRewardedVideoForViewController:(UIViewController *)viewController
{
    //展示广告之前检查视频广告是否已经下载成功
    if ([MTGRewardAdManager.sharedInstance isVideoReadyToPlay:XRMintegralAdUnitId]) {
        //展示视频广告
        [MTGRewardAdManager.sharedInstance showVideo:XRMintegralAdUnitId withRewardId:@"" userId:nil delegate:self viewController:viewController];
    } else{
        [self requestRewardedVideo];
    }
}

#pragma mark - MTGRewardAdLoadDelegate
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId {
    [TalkingData trackEvent:MintegralRewardAdLoadSuccess];
}

- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error {
    [TalkingData trackEvent:MintegralRewardAdLoadFailed];
}

#pragma mark - MTGRewardAdShowDelegate
- (void)onVideoAdShowSuccess:(nullable NSString *)unitId {
    [TalkingData trackEvent:MintegralRewardAdShowSuccess];
}

- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error {
    [TalkingData trackEvent:MintegralRewardAdShowFailed];
}

- (void)onVideoAdClicked:(nullable NSString *)unitId {
    [TalkingData trackEvent:MintegralRewardAdClicked];
}

- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo {
    [TalkingData trackEvent:MintegralRewardAdRewardSuccess];
    [self requestRewardedVideo];
}

@end
