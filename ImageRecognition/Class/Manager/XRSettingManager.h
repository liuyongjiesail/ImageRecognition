//
//  XRSettingManager.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRSettingManager : NSObject

+ (instancetype)shared;

- (void)openFeedbackViewController;

@end

NS_ASSUME_NONNULL_END