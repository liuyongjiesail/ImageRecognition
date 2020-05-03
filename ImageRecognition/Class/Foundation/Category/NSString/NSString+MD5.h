//
//  NSString+MD5.h
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/10/21.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MD5)

- (NSString *)MD5Of32BitLower;

- (NSString *)MD5Of32BitUpper;

- (NSString *)MD5Of16BitLower;

- (NSString *)MD5Of16BitUpper;

@end

NS_ASSUME_NONNULL_END
