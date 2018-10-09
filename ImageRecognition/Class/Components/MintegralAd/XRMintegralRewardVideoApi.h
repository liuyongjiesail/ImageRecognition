//
//  RewardedVideoApi.h
//  GoogleAd
//
//  Created by 刘永杰 on  2018/10/3.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XRMintegralRewardVideoApi : NSObject

+ (instancetype)sharedReward;

//打开视频广告
- (void)showRewardedVideoForViewController:(UIViewController *)viewController;

@end
