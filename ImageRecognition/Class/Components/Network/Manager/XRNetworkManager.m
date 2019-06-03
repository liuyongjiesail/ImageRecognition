//
//  XRNetworkManager.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRNetworkManager.h"

@interface XRNetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation XRNetworkManager

+ (instancetype)shared {
    static XRNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XRNetworkManager new];
    });
    return manager;
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
//    XRLog(@"[Server Request]:\n%@\n%@", URLString, parameters);

    [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
        XRLog(@"[Server Response]:\n%@\n%@", URLString, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.code);
        }
    }];
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    XRLog(@"[Server Request]:\n%@\n%@", URLString, parameters);
    
    [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
        XRLog(@"[Server Response]:\n%@\n%@", URLString, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.code);
        }
    }];
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        // 设置超时时间
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 8.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSMutableSet *acceptContentTypes = [NSMutableSet set];
        // 添加需要的类型
        acceptContentTypes.set = _manager.responseSerializer.acceptableContentTypes;
        [acceptContentTypes addObject:@"text/html"];
        // 给acceptableContentTypes赋值
        _manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    }
    return _manager;
}

@end
