//
//  ClassiflyView.h
//  ButtonTestDemo
//
//  Created by 刘永杰 on 2018/10/16.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XRClassifySelectView;

@protocol XRClassifySelectViewDelegate <NSObject>

- (void)classifySelectView:(XRClassifySelectView *)view didSelectIndex:(NSInteger)index;

@end

@interface XRClassifySelectView : UIView

@property (assign, readonly, nonatomic) NSInteger selectedIndex;

- (void)configureDelegate:(id<XRClassifySelectViewDelegate>)delegate classifyArray:(NSArray *)classifyArray;

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
