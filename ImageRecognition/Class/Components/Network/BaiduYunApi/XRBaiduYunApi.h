//
//  XRBaiduYunApi.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRBaiduYunApi : NSObject

+ (void)fetchBaiduYunTokenSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)recognitionImage:(UIImage *)image classify:(NSString *)classify success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
