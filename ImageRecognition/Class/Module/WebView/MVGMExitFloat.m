//
//  MVGMExitFloat.m
//  MetaAppVideo
//
//  Created by 刘永杰 on 2020/3/5.
//  Copyright © 2020 MetaApp. All rights reserved.
//

#import "MVGMExitFloat.h"

#define kSpecY 20
#define kFloatHeight 44

typedef NS_ENUM(NSUInteger, MVFloatState) {
    MVFloatStateNormal,
    MVFloatStateAlpha,
    MVFloatStateExit,
};

@interface MVGMExitFloat ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIImageView *arrowImageView;

@property (assign, nonatomic) MVFloatState floatState;

@end

@implementation MVGMExitFloat

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static MVGMExitFloat *instance;
    dispatch_once(&onceToken, ^{
        instance = [MVGMExitFloat buttonWithType:UIButtonTypeCustom];
        [instance setupSubviews];
    });
    return instance;
}

- (void)setupSubviews {
    
    self.frame = CGRectMake(0,  SAFEAREINSETS.top + kSpecY, 79, kFloatHeight);
    UIImage *img = [UIImage imageNamed:@"exit_background_image"];
      img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:img forState:UIControlStateNormal];
    [self setBackgroundImage:img forState:UIControlStateHighlighted];
    
    self.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.3].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 20;
    self.layer.cornerRadius = 16;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.logoImageView];
    
    self.contentLabel.frame = self.bounds;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.logoImageView.mas_left).offset(-10);
    }];

}

- (void)showInView:(UIView *)view {
    
    self.frame = CGRectMake(0,  SAFEAREINSETS.top + kSpecY * 2.5, 79, kFloatHeight);
    self.floatState = MVFloatStateExit;
    [view addSubview:self];
}

- (void)setFloatState:(MVFloatState)floatState {
    _floatState = floatState;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.floatState == MVFloatStateAlpha) {
            self.width = 52;
            self.contentLabel.hidden = YES;
            self.logoImageView.hidden = NO;
            self.arrowImageView.hidden = YES;
            self.alpha = 0.7;
        } else if (self.floatState == MVFloatStateNormal) {
            self.width = 63;
            self.contentLabel.hidden = YES;
            self.logoImageView.hidden = NO;
            self.arrowImageView.hidden = NO;
            self.alpha = 1;
        } else {
            self.width = 79;
            self.contentLabel.hidden = NO;
            self.arrowImageView.hidden = YES;
            self.logoImageView.hidden = YES;
            self.alpha = 1;
            [self doAnimationExit];
        }
    }];
}

- (void)tapAction {
    [self.layer removeAllAnimations];
    if (self.floatState == MVFloatStateExit) {
        [UIViewController.currentContentViewController.navigationController popViewControllerAnimated:YES];
    }
    if (self.floatState == MVFloatStateAlpha ||
        self.floatState == MVFloatStateNormal) {
        self.floatState = MVFloatStateExit;
    }
}

- (void)superViewTapAction {
    
    if (self.floatState == MVFloatStateExit) {
        self.floatState = MVFloatStateNormal;
        [self doAnimationNormal];
    } else if (self.floatState == MVFloatStateNormal) {
        self.floatState = MVFloatStateAlpha;
    }
}

#pragma mark - Animation

- (void)doAnimationExit {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.floatState != MVFloatStateExit) {
            return;
        }
        self.floatState = MVFloatStateNormal;
        [self doAnimationNormal];
    });
}

- (void)doAnimationNormal {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.floatState != MVFloatStateNormal) {
            return;
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.7;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.floatState = MVFloatStateAlpha;
        });
    });
}

#pragma mark - 拖动

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (self.floatState == MVFloatStateExit) { //退出状态，不可拖动
        return;
    }
    
    //当前的point
    CGPoint currentP = [touch locationInView:self];
    //以前的point
    CGPoint preP = [touch previousLocationInView:self];
    
    //Y轴偏移的量
    CGFloat offsetY = currentP.y - preP.y;
    
    if ([self limitView:[touches anyObject]]) {
        return;
    }
    
    self.transform = CGAffineTransformTranslate(self.transform, 0, offsetY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self limitView:[touches anyObject]];
}

- (BOOL)limitView:(UITouch *)touch {
    CGFloat screenHeight = self.superview.bounds.size.height;
    if (touch.view.y < kSpecY) {
        touch.view.y = kSpecY;
        return YES;
    }
    if (touch.view.y > screenHeight - kSpecY - kFloatHeight) {
        touch.view.y = screenHeight - kSpecY - kFloatHeight;
        return YES;
    }
    return NO;
}

#pragma mark - Lazy Loading

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.new;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.text = @"退出游戏";
        _contentLabel.textColor = HEX(0xFF5000);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = UIImageView.new;
        _logoImageView.image = [UIImage imageNamed:@"exit_float_logo"];
    }
    return _logoImageView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = UIImageView.new;
        _arrowImageView.image = [UIImage imageNamed:@"exit_arrow"];
    }
    return _arrowImageView;
}

@end
