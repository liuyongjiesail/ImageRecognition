//
//  MobileconfigModel.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/5/23.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MobileconfigModel : NSObject

@property (copy, nonatomic) NSString *configId;
@property (copy, nonatomic) NSString *productId;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL   isFree;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *originalPrice;
@property (copy, nonatomic) NSString *appName;
@property (copy, nonatomic) NSString *appIcon;
@property (copy, nonatomic) NSString *downloadUrl;
@property (copy, nonatomic) NSString *sales;
@property (strong, nonatomic) NSArray *userIds;

@end

NS_ASSUME_NONNULL_END
