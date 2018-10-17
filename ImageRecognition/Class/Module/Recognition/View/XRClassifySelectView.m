//
//  ClassiflyView.m
//  ButtonTestDemo
//
//  Created by 刘永杰 on 2018/10/16.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRClassifySelectView.h"
#import "UIView+Frame.h"

#define kButtonWidth  60
#define kButtonHeight 40

@interface XRClassifySelectView ()

@property (strong, nonatomic) UIView    *contentView;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIButton  *selectedButton;
@property (weak, nonatomic)   id<XRClassifySelectViewDelegate> delegate;

@end

@implementation XRClassifySelectView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.frame = CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width - 60, kButtonHeight);
    self.layer.masksToBounds = YES;
    
    self.contentView = [UIView new];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
}

- (void)configureDelegate:(id<XRClassifySelectViewDelegate>)delegate classifyArray:(NSArray *)classifyArray {
    self.delegate = delegate;
    
    self.contentView.width = kButtonWidth * classifyArray.count;
    
    for (int i = 0; i < classifyArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * kButtonWidth, 0, kButtonWidth, kButtonHeight);
        [button setTitle:classifyArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLORDF55E6] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [self.contentView addSubview:button];
    }
    
}

#pragma mark - Public Methods

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation {
    
    UIButton *button = (UIButton *)[self viewWithTag:selectedIndex + 100];
    [self switchButton:button animation:animation];

}

#pragma mark - Private Methods

- (void)buttonAction:(UIButton *)sender {
    
    [self switchButton:sender animation:YES];
}

- (void)switchButton:(UIButton *)button animation:(BOOL)animation {
    
    if (self.selectedButton != button) {
        
        button.selected = !button.selected;
        self.selectedButton.selected = !self.selectedButton.selected;
        self.selectedButton = button;
        
        self.selectedIndex = button.tag - 100;
        [UIView animateWithDuration:animation ? 0.25 : 0 animations:^{
            self.contentView.x = (SCREEN_WIDTH - 40)/2.0 - kButtonWidth * self.selectedIndex - kButtonWidth/2.0;
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(classifySelectView:didSelectIndex:)]) {
            [self.delegate classifySelectView:self didSelectIndex:self.selectedIndex];
        }
    }
    
}

@end
