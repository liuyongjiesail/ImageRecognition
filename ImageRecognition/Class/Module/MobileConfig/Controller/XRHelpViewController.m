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
        _titileLabel = [UILabel labWithText:@"解锁功能升级，1分钟即可秒解，具体解锁步骤请直接点击右上角“观看视频教程”。\n注意：最新解锁功能需要最新软件版本【1.4.0】的支持，若未升级，请前往App Store更新最新版本。\n\n如您在解锁中遇到任何困难，可随时联系客服QQ：2171789880 \n\n\n 可请忽略下面的图片" fontSize:16 textColorString:COLOR333333];
        _titileLabel.numberOfLines = 0;
    }
    return _titileLabel;
}

@end
