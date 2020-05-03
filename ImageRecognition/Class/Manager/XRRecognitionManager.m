//
//  XRRecognitionManager.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRRecognitionManager.h"

@implementation XRRecognitionManager

+ (instancetype)shared {
    static XRRecognitionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XRRecognitionManager new];
    });
    return manager;
}

- (void)setBaiduYunToken:(NSString *)token expirationTime:(NSString *)expirationTime {
    
    [NSUserDefaults.standardUserDefaults setObject:token forKey:XRUserDefaultsBaiduYunToken];
    [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%lld", time(0) + [expirationTime longLongValue]] forKey:XRUserDefaultsTokenExpirationTime];
}

- (void)setTextToken:(NSString *)token expirationTime:(NSString *)expirationTime {
    [NSUserDefaults.standardUserDefaults setObject:token forKey:XRUserDefaultsBaiduYunTextToken];
    [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%lld", time(0) + [expirationTime longLongValue]] forKey:XRUserDefaultsTextTokenExpirationTime];
}

- (BOOL)isExpiration {
    if ([[NSUserDefaults.standardUserDefaults objectForKey:XRUserDefaultsTokenExpirationTime] longLongValue] < time(0) + 129600) {  //暂定半个月请求一次
        return YES;
    }
    XRLog(@"距离过期还剩：%lld 秒", [[NSUserDefaults.standardUserDefaults objectForKey:XRUserDefaultsTokenExpirationTime] longLongValue] - time(0));
    return NO;
}

- (BOOL)isTextExpiration {
    if ([[NSUserDefaults.standardUserDefaults objectForKey:XRUserDefaultsTextTokenExpirationTime] longLongValue] < time(0) + 129600) {  //暂定半个月请求一次
        return YES;
    }
    XRLog(@"距离过期还剩：%lld 秒", [[NSUserDefaults.standardUserDefaults objectForKey:XRUserDefaultsTokenExpirationTime] longLongValue] - time(0));
    return NO;
}

- (NSString *)baiduYunToken {
    return [NSUserDefaults.standardUserDefaults objectForKey:XRUserDefaultsBaiduYunToken];
}

- (NSString *)textToken {
    return [NSUserDefaults.standardUserDefaults objectForKey:XRUserDefaultsBaiduYunTextToken];
}

@end
