//
//  XRMobileconfigApi.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/5/24.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRMobileconfigApi : NSObject

+ (void)fetchMobileconfigListSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)fetchInreviewConfigSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)fetchHelpconfigSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
