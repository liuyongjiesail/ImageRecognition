//
//  XRHelpViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/5/25.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import "XRHelpViewController.h"
#import "XRMobileconfigApi.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface XRHelpViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton    *button;
@property (strong, nonatomic) UILabel     *titileLabel;

@property (strong, nonatomic) NSString *videoUrl;

@end

@implementation XRHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.button];
    [self.view addSubview:self.titileLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"观看视频教程" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    [self.titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(20 + 64 + SAFEAREINSETS.top);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titileLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH/2.5);
        make.height.mas_equalTo([UIImage imageNamed:@"paycode"].size.height * (SCREEN_WIDTH/2.5)/[UIImage imageNamed:@"paycode"].size.width);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
    }];
    
    [XRMobileconfigApi fetchHelpconfigSuccess:^(id responseDict) {
        
        self.titileLabel.text = responseDict[@"helpTitle"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:responseDict[@"payUrl"]] placeholderImage:[UIImage imageNamed:@"paycode"]];
        self.videoUrl = responseDict[@"videoUrl"];
    } failure:^(NSInteger errorCode) {
        
    }];
    
}

- (void)saveAction {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, nil, nil);
    [MBProgressHUD showSuccess:@"保存成功"];
}

- (void)rightAction {
    AVPlayerViewController *VC = [AVPlayerViewController new];
    VC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.videoUrl]];
    [self presentViewController:VC animated:NO completion:nil];
}

#pragma makr - Lazy Loading

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"paycode"];
    }
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"保存到相册" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor colorWithString:@"#F35A21"];
        _button.layer.cornerRadius = 4;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)titileLabel {
    if (!_titileLabel) {
        _titileLabel = [UILabel labWithText:@"1.保存如下支付宝二维码到相册\n2.复制您的用户ID到剪切板\n3.点击你要解锁的安装软件\n4.前往支付宝，点击左上角扫一扫进入，点击右上角相册选择您保持的支付二维码，选择你要购买的软件，将你复制好的用户ID粘贴在支付备注中，最后支付\n5.支付成功后等待大约3~10分钟，手动下拉刷新软件列表页，您需要的安装软件就变成了“安装“状态" fontSize:16 textColorString:COLOR333333];
        _titileLabel.numberOfLines = 0;
    }
    return _titileLabel;
}

@end
