//
//  NSBundle+XLAppInfo.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/15.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (XLAppInfo)

/**
 应用名称
 */
+ (NSString *)appName;

/**
 包名
 */
+ (NSString *)appBundleName;

/**
 版本号
 */
+ (NSString *)appVersion;

/**
 数字型版本号（不带小数点）
 */
+ (NSString *)appVersionNumber;

@end
