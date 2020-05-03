//
//  NSString+MD5.m
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/10/21.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

- (NSString *)MD5Of32BitLower {
    const char *data = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
         [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

- (NSString *)MD5Of32BitUpper {
    const char *data = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5Str appendFormat:@"%02X", result[i]];
    }
    return md5Str;
}

- (NSString *)MD5Of16BitLower {
    return [[self MD5Of32BitLower] substringWithRange:NSMakeRange(8, 16)];
}

- (NSString *)MD5Of16BitUpper {
    return [[self MD5Of32BitUpper] substringWithRange:NSMakeRange(8, 16)];
}

@end
