//
//  NSURL+Query.h
//  MetaAppVideo
//
//  Created by 刘永杰 on 2019/10/25.
//  Copyright © 2019 MetaApp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Query)

- (NSString *)queryStringFromParameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
