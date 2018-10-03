//
//  XRRecognitionManager.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRRecognitionManager : NSObject

@property (copy, readonly, nonatomic) NSString          *baiduYunToken;
 /// 是否过期
@property (assign, nonatomic, getter=isExpiration) BOOL expiration;

+ (instancetype)shared;

- (void)setBaiduYunToken:(NSString *)token expirationTime:(NSString *)expirationTime;

@end

NS_ASSUME_NONNULL_END
