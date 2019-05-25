//
//  XRMobileconfigApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/5/24.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import "XRMobileconfigApi.h"
#import "XRRecognitionManager.h"

static NSString * const MobileconfigListURL = @"http://sailip.com/mobileconfigList.json";
static NSString * const InreviewconfigURL = @"http://sailip.com/inreviewconfig.json";
static NSString * const HelpconfigURL = @"http://sailip.com/helpconfig.json";

@implementation XRMobileconfigApi

+ (void)fetchMobileconfigListSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared GET:MobileconfigListURL parameters:@{} success:success failure:failure];
}

+ (void)fetchInreviewConfigSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared GET:InreviewconfigURL parameters:@{} success:success failure:failure];
}

+ (void)fetchHelpconfigSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared GET:HelpconfigURL parameters:@{} success:success failure:failure];
}

@end
