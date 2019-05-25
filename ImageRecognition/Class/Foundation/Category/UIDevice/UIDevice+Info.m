//
//  UIDevice+Info.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/5/23.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import "UIDevice+Info.h"
#import "KeychainService.h"
#import <AdSupport/AdSupport.h>

@implementation UIDevice (Info)

+ (NSString *)keychainIDFA {
    NSString *key = @"keychainIDFA";
    NSString *keychainIDFA = [KeychainService itemForKey:key];
    
    //初始没有值时，取出设备的idfa，存入钥匙串中
    if (keychainIDFA == nil) {
        keychainIDFA = UIDevice.IDFA;
        //如果开启了限制广告跟踪，idfa为"00000000-0000-0000-0000-000000000000"，改用uuid
        if ([keychainIDFA containsString:@"00000000-"]) {
            keychainIDFA = UIDevice.UUID;
        }
        [KeychainService setItem:keychainIDFA forKey:key];
    }
    
    return keychainIDFA;
}

+ (NSString *)IDFA {
    return ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
}

+ (NSString *)UUID {
    return NSUUID.UUID.UUIDString;
}

@end
