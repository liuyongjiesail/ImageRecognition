//
//  XRJuHeApi.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRJuHeApi : NSObject

+ (void)fetchToadyOnHistory:(NSString *)date success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)fetchToadyDetailInfo:(NSString *)eventId success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
