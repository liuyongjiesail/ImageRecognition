//
//  NSBundle+XLAppInfo.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/15.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSBundle+XLAppInfo.h"

@implementation NSBundle (XLAppInfo)

/**
 应用名称
 */
+ (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/**
 包名
 */
+ (NSString *)appBundleName {
    return [[NSBundle mainBundle] bundleIdentifier];
}

/**
 版本号
 */
+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 数字型版本号（不带小数点）
 */
+ (NSString *)appVersionNumber {
    return [self appBuild];
}

/**
 bulid号
 */
+ (NSString *)appBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
