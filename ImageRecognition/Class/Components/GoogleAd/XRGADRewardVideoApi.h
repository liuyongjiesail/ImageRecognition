//
//  XRGADRewardVideoApi.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/5/13.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRGADRewardVideoApi : NSObject

+ (instancetype)shared;

- (void)perloadAd;

- (void)showCompletion:(void(^)(void))completion;

- (void)removeAds;

@end

NS_ASSUME_NONNULL_END
