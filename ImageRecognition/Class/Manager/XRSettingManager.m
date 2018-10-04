//
//  XRSettingManager.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRSettingManager.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

@interface XRSettingManager ()

@property (strong, nonatomic) YWFeedbackKit *feedbackKit;

@end

@implementation XRSettingManager

+ (instancetype)shared {
    static XRSettingManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XRSettingManager new];
    });
    return manager;
}

- (void)openFeedbackViewController {
    
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(BCFeedbackViewController *viewController, NSError *error) {
        
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
        [viewController setCloseBlock:^(UIViewController *aParentController){
            [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - Lazy Loading

- (BCFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:XRAliyunAppKey appSecret:XRAliyunAppSecret];
    }
    return _feedbackKit;
}

@end
