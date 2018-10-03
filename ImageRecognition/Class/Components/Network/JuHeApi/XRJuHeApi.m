//
//  XRJuHeApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRJuHeApi.h"

@implementation XRJuHeApi

+ (void)fetchToadyOnHistory:(NSString *)date success:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared GET:juheTodayOnHistoryURL parameters:[self combiningParameters:@{@"date": date}] success:success failure:failure];
}

+ (void)fetchToadyDetailInfo:(NSString *)eventId success:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared GET:juheEventDetailURL parameters:[self combiningParameters:@{@"e_id": eventId}] success:success failure:failure];
}

+ (NSDictionary *)combiningParameters:(NSDictionary *)dic {
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [resultDic setObject:XRJuHeAppKey forKey:@"key"];
    [resultDic addEntriesFromDictionary:dic];
    return resultDic;
}

@end
