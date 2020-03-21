//
//  XRThirdPartyServiceManager.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRVendorServiceManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "XRGADInterstitialApi.h"

@implementation XRVendorServiceManager

+ (instancetype)shared {
    static XRVendorServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XRVendorServiceManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        /** 第三方统计服务 **/
        [TalkingData sessionStarted:XRTakingDataAppID withChannelId:XRTakingDataAppChannel];
        //开启崩溃日志捕获
        [TalkingData setExceptionReportEnabled:YES];
        
        /** Google Ad **/
        [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
        
        [XRGADInterstitialApi.shared requestInterstitialSuccess:nil];
        
    }
    return self;
}

@end
