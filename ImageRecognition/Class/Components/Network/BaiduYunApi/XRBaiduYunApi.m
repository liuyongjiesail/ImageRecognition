//
//  XRBaiduYunApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRBaiduYunApi.h"

@implementation XRBaiduYunApi

+ (void)fetchBaiduYunTokenSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    
    return;
    [XRNetworkManager.shared POST:[self tokenURL] parameters:[self tokenRequestDictionary] success:^(id responseDict) {
        
        
    } failure:^(NSInteger errorCode) {
        
    }];
}

+ (void)recognitionImage:(UIImage *)image classify:(NSString *)classify success:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared POST:[self imageClassifyURL:classify]
                       parameters:[self imageClassifyDictionary:image]
                          success:^(id responseDict) {
                              if (success) {
                                  success(responseDict);
                              }
                          } failure:^(NSInteger errorCode) {
                              if (failure) {
                                  failure(errorCode);
                              }
                          }];
}

#pragma mark - Private Methods

/**
 获取TokenURL

 @return TokenURL
 */
+ (NSString *)tokenURL {
    return [@[baiduYunDomain, baiduYunOauth, baiduYunToken] componentsJoinedByString: @"/"];
}

+ (NSDictionary *)tokenRequestDictionary {
    return @{@"grant_type"    : @"client_credentials",
             @"client_id"     : XRBaiduYunAPIKey,
             @"client_secret" : XRBaiduYunSecretKey};
}

/**
 获取识别图片URL

 @param string 分类（通用、植物、动物、车等）
 @return 识别图片URL
 */
+ (NSString *)imageClassifyURL:(NSString *)string {
    return[ @[baiduYunDomain, baiduYunImageClassify, string] componentsJoinedByString:@"/"];
}

+ (NSDictionary *)imageClassifyDictionary:(UIImage *)image {
    return @{@"access_token" : @"24.f0cca009f21cf4061ca31b8431a804ca.2592000.1541048487.282335-14300809",
             @"image" :  [[NSString alloc] initWithData:[GTMBase64 encodeData:UIImagePNGRepresentation(image)]  encoding:NSUTF8StringEncoding],
             @"baike_num" : @"6"
             };
}

@end
