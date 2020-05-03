//
//  NSURL+Query.m
//  MetaAppVideo
//
//  Created by 刘永杰 on 2019/10/25.
//  Copyright © 2019 MetaApp. All rights reserved.
//

#import "NSURL+Query.h"

@implementation NSURL (Query)

- (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    return [NSURL URLWithString:[self.absoluteString stringByAppendingFormat:self.query ? @"&%@" : @"?%@", AFQueryStringFromParameters(parameters)]].absoluteString;
}

@end
