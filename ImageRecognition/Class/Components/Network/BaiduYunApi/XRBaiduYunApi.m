//
//  XRBaiduYunApi.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRBaiduYunApi.h"
#import "XRRecognitionManager.h"

@implementation XRBaiduYunApi

+ (void)fetchBaiduYunTokenSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    
    if (XRRecognitionManager.shared.isExpiration) {
        
        [XRNetworkManager.shared POST:[self tokenURL] parameters:[self tokenRequestDictionary] success:^(id responseDict) {
            
            [XRRecognitionManager.shared setBaiduYunToken:responseDict[@"access_token"] expirationTime:responseDict[@"expires_in"]];
            if (success) {
                success(responseDict);
            }
            
        } failure:^(NSInteger errorCode) {
            
        }];
        
    }
    
    if (XRRecognitionManager.shared.isTextExpiration) {
        [XRNetworkManager.shared POST:[self tokenURL] parameters:[self textYokenRequestDictionary] success:^(id responseDict) {
            
            [XRRecognitionManager.shared setTextToken:responseDict[@"access_token"] expirationTime:responseDict[@"expires_in"]];
            if (success) {
                success(responseDict);
            }
        } failure:^(NSInteger errorCode) {
            
        }];
    }
}

+ (void)recognitionImage:(UIImage *)image classify:(NSString *)classify success:(SuccessBlock)success failure:(FailureBlock)failure {
    [XRNetworkManager.shared POST:[self imageClassifyURL:classify]
                       parameters:[classify isEqualToString:baiduYunClassifyText] ? [self textClassifyDictionary:image] : [self imageClassifyDictionary:image]
                          success:^(id responseDict) {
                              if (success) {
                                  if ([responseDict[@"error_code"] integerValue] == 110) {
                                      [XRBaiduYunApi fetchBaiduYunTokenSuccess:^(id responseDict) {
                                          [self recognitionImage:image classify:classify success:success failure:failure];
                                      } failure:^(NSInteger errorCode) {
                                          
                                      }];
                                      return;
                                  }
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

+ (NSDictionary *)textYokenRequestDictionary {
    return @{@"grant_type"    : @"client_credentials",
             @"client_id"     : XRBaiduYunTextAPIKey,
             @"client_secret" : XRBaiduYunTextSecretKey};
}

/**
 获取识别图片URL

 @param string 分类（通用、植物、动物、车等）
 @return 识别图片URL
 */
+ (NSString *)imageClassifyURL:(NSString *)string {
    if ([string isEqualToString:baiduYunClassifyText]) {
        return[@[baiduYunDomain, baiduYunTextClassify, string] componentsJoinedByString:@"/"];
    }
    return[ @[baiduYunDomain, baiduYunImageClassify, string] componentsJoinedByString:@"/"];
}

+ (NSDictionary *)imageClassifyDictionary:(UIImage *)image {
    return @{@"access_token" : XRRecognitionManager.shared.baiduYunToken ?: @"",
             @"image" :  [[NSString alloc] initWithData:[GTMBase64 encodeData:UIImagePNGRepresentation(image)]  encoding:NSUTF8StringEncoding],
             @"baike_num" : @"6"
             };
}

+ (NSDictionary *)textClassifyDictionary:(UIImage *)image {
    return @{@"access_token" : XRRecognitionManager.shared.textToken ?: @"",
             @"image" :  [[NSString alloc] initWithData:[GTMBase64 encodeData:UIImagePNGRepresentation(image)]  encoding:NSUTF8StringEncoding],
             };
}

@end
