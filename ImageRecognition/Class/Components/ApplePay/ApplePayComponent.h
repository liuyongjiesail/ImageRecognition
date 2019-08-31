//
//  ApplePayComponent.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/6/4.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplePayComponent : NSObject

+ (instancetype)sharedInstance;

- (void)purchase:(NSString *)productId success:(void(^)(void))success failure:(void(^)(NSString *error))failure;

@end

NS_ASSUME_NONNULL_END
