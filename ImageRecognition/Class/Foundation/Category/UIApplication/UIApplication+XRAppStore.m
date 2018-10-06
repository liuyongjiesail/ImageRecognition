//
//  UIApplication+XRAppStore.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "UIApplication+XRAppStore.h"
#import <StoreKit/StoreKit.h>

@implementation UIApplication (XRAppStore)

- (void)commentApplicationToAppStore {
    
    NSURL *appStoreURL = [NSURL URLWithString:[self appStoreURLString]];
    
    if (@available(iOS 10.3, *)){
        if ([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            [SKStoreReviewController requestReview];
        } else {
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
    } else {
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}

- (NSString *)appStoreURLString {
    return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/twitter/id%@?mt=8", XRApplicationAppID];
}

- (void)shareApplicationToFriends {
    //分享的标题
    NSString *textToShare = [NSString stringWithFormat:@"我在用《%@》识别万物，你来吗？- 人工智能深度识别", NSBundle.appName];
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"app_icon"];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:self.appStoreURLString];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    if (@available(iOS 9.0, *)) {
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeOpenInIBooks, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeSaveToCameraRoll];
    } else {
        // Fallback on earlier versions
    }
    [[UIViewController currentViewController] presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

@end
