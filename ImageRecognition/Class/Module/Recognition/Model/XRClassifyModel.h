//
//  XRClassifyModel.h
//  ButtonTestDemo
//
//  Created by 刘永杰 on 2018/10/17.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRClassifyModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *classifyURL;

@end

NS_ASSUME_NONNULL_END
