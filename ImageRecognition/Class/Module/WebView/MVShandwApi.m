//
//  MXShandwApi.m
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/11/9.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import "MVShandwApi.h"

static NSString * const Shandw_ChannelId = @"12686";
static NSString * const Shandw_Key = @"a2e1c26c87634f3aab9611f1e688e20a";

@implementation MVShandwApi

#pragma mark - Public Methods

+ (NSString *)generateUrlGmId:(NSString *)gmId {
    NSString *timeStr = [NSString stringWithFormat:@"%ld",time(0)];
    NSString *sign = [self generateSignTimestamp:timeStr];
    NSMutableDictionary *params = [self params].mutableCopy;
    [params setObject:timeStr forKey:@"time"];
    [params setObject:sign forKey:@"sign"];
    [params setObject:gmId forKey:@"gid"];
    [params addEntriesFromDictionary:[self hiddenParams]];
    return [[NSURL URLWithString:@"http://www.shandw.com/auth/"] queryStringFromParameters:params];
}

+ (NSString *)generateGmCenterUrl {
    NSString *timeStr = [NSString stringWithFormat:@"%ld",time(0)];
    NSString *sign = [self generateSignTimestamp:timeStr];
    NSMutableDictionary *params = [self params].mutableCopy;
    [params setObject:timeStr forKey:@"time"];
    [params setObject:sign forKey:@"sign"];
    [params setObject:@"2" forKey:@"sdw_simple"];
    [params setObject:@"freegame" forKey:@"initTab"];
    [params addEntriesFromDictionary:[self hiddenParams]];
    return [[NSURL URLWithString:@"http://www.shandw.com/auth/"] queryStringFromParameters:params];
}

+ (NSString *)URLEncodedString:(NSString *)str {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

#pragma mark - Private Methods

+ (NSString *)generateSignTimestamp:(NSString *)timestamp {
    NSMutableDictionary *params = [self params].mutableCopy;
    [params setObject:timestamp forKey:@"time"];
    NSArray *sortedArray = @[@"channel", @"openid", @"time", @"nick", @"avatar", @"sex", @"phone"];
    NSString *paramsString = [self sortedArray:sortedArray params:params];
    return [[NSString stringWithFormat:@"%@%@", paramsString, Shandw_Key] MD5Of32BitLower];
}

+ (NSDictionary *)params {
    
    NSString *avatar = @"http://app_avatar";
    
    return @{@"channel" : Shandw_ChannelId,
             @"openid"  : UIDevice.keychainIDFA,
             @"nick"    : UIDevice.keychainIDFA,
             @"avatar"  : avatar,
             @"sex"     : @(1),
             @"phone"   : @"",
             };
}

+ (NSDictionary *)hiddenParams {
    return @{@"sdw_ld" : @1,
             @"sdw_tl" : @1,
             @"sdw_kf" : @1,
             @"sdw_dl" : @1,
             @"sdw_qd" : @1,
             @"shieldSDW" : @"true",
             @"puregame" : @"true"
             };
}

+ (NSString *)sortedArray:(NSArray *)keys params:(NSDictionary *)params {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0 ; i< keys.count; i++) {
        
        NSString *tmpStr;
        if (i == 0) {
            tmpStr = [NSString stringWithFormat:@"%@=%@", keys[i], params[keys[i]]];
        } else {
            //拼接时加&
            tmpStr = [NSString stringWithFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
        
        [result appendString:tmpStr];
    }
    
    return result;
}

@end
