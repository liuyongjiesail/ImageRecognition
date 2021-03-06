//
//  UIApplication+XRAppStore.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (XRAppStore)

- (void)commentApplicationToAppStore;

- (void)shareApplicationToFriends;

- (NSString *)appStoreURLString;

@end

NS_ASSUME_NONNULL_END
