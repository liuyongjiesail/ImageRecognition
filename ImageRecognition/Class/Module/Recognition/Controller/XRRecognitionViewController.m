//
//  XRRecognitionViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/1.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRRecognitionViewController.h"
#import "XRRecognitionView.h"
#import "AVCaptureManager.h"
#import "XRBaiduYunApi.h"
#import "XRHomeViewController.h"
#import "XRIdentifyResultsModel.h"
#import "XRRecognitionListViewController.h"

@interface XRRecognitionViewController () <XRRecognitionViewDelegate>

@property (strong, nonatomic) AVCaptureManager *sessionManager;
@property (strong, nonatomic) XRRecognitionView *shootView;

@property (strong, nonatomic) UIImage *tempImage;

@end

@implementation XRRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.sessionManager = [AVCaptureManager sharedManager];
    if ([self.sessionManager isCanUseCamera]) {
        [self initCaptureDevice];
    }
    
    [self setNavigationBar];
    
    [XRBaiduYunApi fetchBaiduYunTokenSuccess:^(id responseDict) {
        
    } failure:^(NSInteger errorCode) {
        
    }];
    
}

#pragma mark - CustomEvent

- (void)setNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"today_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)leftBarButtonItemAction {
    [self showViewController:[XRHomeViewController new] sender:nil];
}

/**
 初始化摄像设备
 */
- (void)initCaptureDevice {
    
    //初始化摄像头设备
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.sessionManager captureSessionPreviewLayer:^(AVCaptureVideoPreviewLayer *previewLayer) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view.layer addSublayer:previewLayer];
                [self.view bringSubviewToFront:self.shootView];
                //开始捕获
                [self.sessionManager startRunning];

            });
        }];
    });
    
    //自定义图层
    self.shootView = [[XRRecognitionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.shootView.delegate = self;
    [self.view addSubview:self.shootView];
    
}

#pragma mark - RecognitionAction

- (void)recognitionAction:(UIImage *)image {
    
    [MBProgressHUD showMessage:@"识别中..." toView:self.view];
    [XRBaiduYunApi recognitionImage:image classify:self.shootView.imageClassifyURL success:^(id responseDict) {
        [MBProgressHUD hideHUDForView:self.view];
        NSMutableArray<XRIdentifyResultsModel *> *dataArray = [NSArray yy_modelArrayWithClass:XRIdentifyResultsModel.class json:responseDict[@"result"]].mutableCopy;
        
        if (dataArray.count == 1 && [dataArray.firstObject.name hasPrefix:@"非"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"该物体%@，请选择其他类别试试看！", dataArray.firstObject.name] time:3];
            return;
        }
        
        XRRecognitionListViewController *listVC = [XRRecognitionListViewController new];
        listVC.title = [NSString stringWithFormat:@"%@ - AI 深度识别", self.shootView.imageClassifyString];
        listVC.dataArray = dataArray;
        [self showViewController:listVC sender:nil];
        
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"识别失败"];
    }];
}

#pragma mark - ShootViewDelegateAction

/**
 摄像头切换
 */
- (void)switchAction {
    [self.sessionManager switchFrontAndBackCameras];
}

/**
 关闭
 */
- (void)photosAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 对焦
 */
- (void)focusingActionAtPoint:(CGPoint)point {
    [self.sessionManager focusingAtPoint:point];
}

/**
 拍照
 */
- (void)shootAction {
    
    [self.sessionManager shootImage:^(UIImage *image) {
        [self.shootView shootComplete];
        [self.sessionManager stopRunning];
        self.tempImage = image;
        
        [self recognitionAction:image];
        
    }];
}

/**
 取消重拍
 */
- (void)cancleAction {
    [self.sessionManager startRunning];
}

/**
 完成拍照
 */
- (void)sureAction {
    [self recognitionAction:self.tempImage];
}

@end
