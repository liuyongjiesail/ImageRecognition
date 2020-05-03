//
//  MXBaseNavigationController.h
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/10/28.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import "RTRootNavigationController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXNavigationController : RTRootNavigationController

@property (assign, nonatomic) BOOL enableRightGesture; // default YES
@property (assign, nonatomic) BOOL closeHidden; // default YES
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *closeButton;

- (UIButton *)createBackButton;

@end

NS_ASSUME_NONNULL_END
