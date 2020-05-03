//
//  ShootView.m
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "XRRecognitionView.h"
#import "XRClassifyModel.h"
#import "XRClassifySelectView.h"

@interface XRRecognitionView ()<XRClassifySelectViewDelegate>

@property (strong, nonatomic) UIView   *focusplace;
@property (strong, nonatomic) UIView   *leftplace;     //左占位
@property (strong, nonatomic) UIView   *rightplace;    //右占位
@property (strong, nonatomic) UIButton *photosButton;   //相册
@property (strong, nonatomic) UIButton *shootButton;   //拍照
@property (strong, nonatomic) UIImageView *focusView;  //对焦框
@property (strong, nonatomic) XRClassifySelectView *classifySelectView; //分段选择
@property (strong, nonatomic) UIImageView *classifyImageView; //分段选择
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSArray <XRClassifyModel *>*classifyModelArray;

@end

@implementation XRRecognitionView

- (void)setupViews {
    
    //创建手势
    UISwipeGestureRecognizer *leftSwipe= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
    
    self.titleLabel = [UILabel labWithText:@"" fontSize:18 textColorString:COLORFFFFFF];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.titleLabel];
    
    self.reminderLabel = [UILabel labWithText:@"" fontSize:15 textColorString:COLORFFFFFF];
    [self addSubview:self.reminderLabel];
    
    //初始化
    self.classifySelectView = [XRClassifySelectView new];
    [self.classifySelectView configureDelegate:self classifyArray:[self.classifyModelArray valueForKeyPath:@"title"]];
    [self.classifySelectView setSelectedIndex:3 animation:NO];
    
    //添加到视图
    [self addSubview:self.classifySelectView];
    
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
    
    self.classifyImageView = [UIImageView new];
    self.classifyImageView.image = [UIImage imageNamed:self.imageClassifyImageName];
    [shootButton addSubview:self.classifyImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusingGesture:)];
    [_focusplace addGestureRecognizer:tapGesture];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.focusplace.mas_top).offset(-20);
    }];
    
    [self.reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.classifySelectView.mas_top).offset(-25);
    }];
    
    [self.classifySelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.shootButton.mas_top).offset(-15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
    }];
    
    //layout
    [shootButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(35+SAFEAREINSETS.bottom));
    }];
    
    [self.classifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shootButton);
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
    return [self.classifyModelArray objectAtIndex:self.classifySelectView.selectedIndex].classifyURL;
}

- (NSString *)imageClassifyString {
    return [self.classifyModelArray objectAtIndex:self.classifySelectView.selectedIndex].title;
}

- (NSString *)imageClassifyImageName {
    return [self.classifyModelArray objectAtIndex:self.classifySelectView.selectedIndex].imageName;
}

//拍照完成
- (void)shootComplete {
    //拍照完成后 拍照按钮消失，取消和完成按钮动画展出
    _shootButton.hidden = YES;
    _cancleButton.hidden = NO;
    _sureButton.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.cancleButton.centerX = self.leftplace.centerX;
        self.sureButton.centerX = self.rightplace.centerX;
        
    }];
}

#pragma mark - XRClassifySelectViewDelegate

- (void)classifySelectView:(XRClassifySelectView *)view didSelectIndex:(NSInteger)index {
    
    self.classifyImageView.image = [UIImage imageNamed:self.imageClassifyImageName];
}

#pragma mark - swipe轻扫手势事件
-(void)swipeAction:(UISwipeGestureRecognizer *)sender{
    
    NSInteger currentIndex = self.classifySelectView.selectedIndex;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (currentIndex <= 0) {
            return;
        }
        [self.classifySelectView setSelectedIndex:currentIndex-1 animation:YES];
    } else {
        if (currentIndex >= self.classifyModelArray.count - 1) {
            return;
        }
        [self.classifySelectView setSelectedIndex:currentIndex+1 animation:YES];
    }
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
        
        self.cancleButton.centerX = self.shootButton.centerX;
        self.sureButton.centerX = self.shootButton.centerX;
        
    } completion:^(BOOL finished) {
        
        self.cancleButton.hidden = YES;
        self.sureButton.hidden = YES;
        self.shootButton.hidden = NO;
        self.photosButton.hidden = NO;
        
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
        self.focusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusView.hidden = YES;
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

- (NSArray *)classifyModelArray {
    if (!_classifyModelArray) {
        NSMutableArray *resultArray = [NSMutableArray array];
        NSArray *titleArray = @[@"菜品", @"车型",@"动物",@"通用",@"取字",@"植物", @"花卉", @"Logo", @"果蔬"];
        NSArray *urlArray = @[baiduYunClassifyDish, baiduYunClassifyCar,baiduYunClassifyAnimal,baiduYunClassifyGeneral, baiduYunClassifyText,baiduYunClassifyPlant,baiduYunClassifyFlower,baiduYunClassifyLogo,baiduYunClassifyIngredient];
        NSArray *imageArray = @[@"dish", @"car",@"animal",@"general",@"general",@"plant", @"huahui", @"logo", @"boluo"];
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XRClassifyModel *model = [XRClassifyModel new];
            model.title = titleArray[idx];
            model.classifyURL = urlArray[idx];
            model.imageName = imageArray[idx];
            [resultArray addObject:model];
        }];
        _classifyModelArray = resultArray.mutableCopy;
    }
    return _classifyModelArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
