//
//  UIViewController+Alert.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/11.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)showAlertWithTitle:(NSString *)title;

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message;

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              actionTitles:(NSArray<NSString *> *)actionTitles
             actionHandler:(void(^)(NSInteger index))actionHandler;

@end
