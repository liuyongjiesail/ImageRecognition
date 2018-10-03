//
//  ShootView.m
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "XRRecognitionView.h"

@interface XRRecognitionView ()

@property (strong, nonatomic) UIButton *sureButton;    //完成
@property (strong, nonatomic) UIButton *cancleButton;  //取消
@property (strong, nonatomic) UIView   *focusplace;
@property (strong, nonatomic) UIView   *leftplace;     //左占位
@property (strong, nonatomic) UIView   *rightplace;    //右占位
@property (strong, nonatomic) UIButton *photosButton;   //相册
@property (strong, nonatomic) UIButton *shootButton;   //拍照
@property (strong, nonatomic) UIImageView *focusView;  //对焦框
@property (strong, nonatomic) UISegmentedControl *segmentedView; //分段选择
@property (strong, nonatomic) UILabel *reminderLabel; //提示文字
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation XRRecognitionView

- (void)setupViews {
    
    self.titleLabel = [UILabel labWithText:@"" fontSize:18 textColorString:COLORFFFFFF];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.titleLabel];
    
    self.reminderLabel = [UILabel labWithText:@"选择合适的类别，有助于更准确识别哦！" fontSize:13 textColorString:COLORD09A6A];
    [self addSubview:self.reminderLabel];
    
    //初始化UISegmentedControl
    self.segmentedView = [[UISegmentedControl alloc] initWithItems:self.titleArray];
    self.segmentedView.apportionsSegmentWidthsByContent = YES;
    self.segmentedView.tintColor = [UIColor whiteColor];
    [self.segmentedView setSelectedSegmentIndex:2];
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.segmentedView setWidth:60.0 forSegmentAtIndex:idx];
    }];
    [self.segmentedView setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} forState:UIControlStateNormal];
    //添加到视图
    [self addSubview:self.segmentedView];
    
    //拍照
    UIButton *shootButton = [self createButtonWithImageNormal:@"camera_shoot" Highlighted:nil];
    [self addSubview:shootButton];
    _shootButton = shootButton;
    
    //左占位
    UIView *leftplace = [UIView new];
    leftplace.backgroundColor = [UIColor clearColor];
    [self addSubview:leftplace];
    _leftplace = leftplace;
    
    //相册
    UIButton *photosButton = [self createButtonWithImageNormal:@"photos_icon" Highlighted:nil];
    [self addSubview:photosButton];
    _photosButton = photosButton;
    
    //完成
    UIButton *sureButton = [self createButtonWithImageNormal:@"camera_comfirm" Highlighted:nil];
    sureButton.hidden = YES;
    [self addSubview:sureButton];
    _sureButton = sureButton;
    
    //取消
    UIButton *cancleButton = [self createButtonWithImageNormal:@"camera_return" Highlighted:nil];
    cancleButton.hidden = YES;
    [self addSubview:cancleButton];
    _cancleButton = cancleButton;
    
    //右占位
    UIView *rightplace = [UIView new];
    rightplace.backgroundColor = [UIColor clearColor];
    [self addSubview:rightplace];
    _rightplace = rightplace;
    
    _focusplace = [UIView new];
    _focusplace.backgroundColor = [UIColor clearColor];
    [self addSubview:_focusplace];
    
    _focusView = [[UIImageView alloc] init];
    _focusView.image = [UIImage imageNamed:@"camera_focusing"];
    _focusView.frame = CGRectMake(0, 0, _focusView.image.size.width, _focusView.image.size.height);
    [self addSubview:_focusView];
    _focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusingGesture:)];
    [_focusplace addGestureRecognizer:tapGesture];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.focusplace.mas_top).offset(-20);
    }];
    
    [self.reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.segmentedView.mas_top).offset(-15);
    }];
    
    [self.segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.shootButton.mas_top).offset(-30);
        make.height.mas_equalTo(35);
    }];
    
    //layout
    [shootButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
    }];
    
    [leftplace mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(shootButton.mas_left);
        
    }];
    
    [photosButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(shootButton);
        make.centerX.equalTo(leftplace).offset(-20);
        make.width.height.equalTo(shootButton);
        
    }];
    
    [rightplace mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.left.equalTo(shootButton.mas_right);
        
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shootButton);
    }];
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shootButton);
    }];
    
    [_focusplace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset((SCREEN_HEIGHT - SCREEN_WIDTH)/3.0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH);
    }];
}

#pragma mark - public methond

- (NSString *)imageClassifyURL {
    switch (self.segmentedView.selectedSegmentIndex) {
        case 0: return baiduYunClassifyCar;
        case 1: return baiduYunClassifyAnimal;
        case 2: return baiduYunClassifyGeneral;
        case 3: return baiduYunClassifyPlant;
        case 4: return baiduYunClassifyLogo;
    }
    return baiduYunClassifyGeneral;
}

- (NSString *)imageClassifyString {
    return [self.titleArray objectAtIndex:self.segmentedView.selectedSegmentIndex];
}

//拍照完成
- (void)shootComplete {
    //拍照完成后 拍照按钮消失，取消和完成按钮动画展出
    _shootButton.hidden = YES;
    _cancleButton.hidden = NO;
    _sureButton.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _cancleButton.centerX = _leftplace.centerX;
        _sureButton.centerX = _rightplace.centerX;
        
    }];
}

#pragma mark - private methond

/**
 事件action
 
 @param sender button点击
 */
- (void)buttonAction:(UIButton *)sender {
    if ([sender isEqual:_shootButton]) {
        //隐藏相册按钮
        _photosButton.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(shootAction)]) {
            [self.delegate shootAction];
        }
    } else if ([sender isEqual:_photosButton]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(photosAction)]) {
            [self.delegate photosAction];
        }
        
    } else if ([sender isEqual:_cancleButton]) {
        
        [self cancleReshoot];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancleAction)]) {
            [self.delegate cancleAction];
        }
        
    } else if ([sender isEqual:_sureButton]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sureAction)]) {
            [self.delegate sureAction];
        }
    }
    
}

//取消重拍
- (void)cancleReshoot {
    [UIView animateWithDuration:0.25 animations:^{
        
        _cancleButton.centerX = _shootButton.centerX;
        _sureButton.centerX = _shootButton.centerX;
        
    } completion:^(BOOL finished) {
        
        _cancleButton.hidden = YES;
        _sureButton.hidden = YES;
        _shootButton.hidden = NO;
        _photosButton.hidden = NO;
        
    }];
}

- (void)focusingGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self focusingAnimationAtPoint:point];
}

//对焦图层动画
- (void)focusingAnimationAtPoint:(CGPoint)point {
    _focusView.center = point;
    _focusView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _focusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _focusView.hidden = YES;
        }];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusingActionAtPoint:)]) {
        [self.delegate focusingActionAtPoint:point];
    }
}

/**
 创建button

 @param normal 正常图片
 @param highlighted 高亮图片
 @return 自定义button
 */
- (UIButton *)createButtonWithImageNormal:(NSString *)normal Highlighted:(NSString *)highlighted {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"车型",@"动物",@"通用",@"植物", @"Logo", nil];
    }
    return _titleArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
