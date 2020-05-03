//
//  MXShandwApi.h
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/11/9.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MVShandwApi : NSObject

+ (NSString *)generateUrlGmId:(NSString *)gmId;

+ (NSString *)generateGmCenterUrl;

@end

NS_ASSUME_NONNULL_END
