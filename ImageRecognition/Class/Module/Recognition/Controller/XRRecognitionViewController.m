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
#import "XRTodayHistoryViewController.h"
#import "XRIdentifyResultsModel.h"
#import "XRRecognitionListViewController.h"
#import "XRSettingViewController.h"
#import <Photos/Photos.h>
#import "XRNetworkManager.h"
#import "XRGADInterstitialApi.h"

@interface XRRecognitionViewController () <XRRecognitionViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) AVCaptureManager *sessionManager;
@property (strong, nonatomic) XRRecognitionView *recognitionView;

@property (strong, nonatomic) UIImage *tempImage;

@end

@implementation XRRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNavigationBar];

    self.sessionManager = [AVCaptureManager sharedManager];
    if ([self.sessionManager isCanUseCamera]) {
        [self initCaptureDevice];
    }
    
    [XRBaiduYunApi fetchBaiduYunTokenSuccess:^(id responseDict) {} failure:^(NSInteger errorCode) {}];
    
}

#pragma mark - CustomEvent

- (void)setNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"today_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(settingAction)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //自定义图层
    self.recognitionView = [[XRRecognitionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.recognitionView.delegate = self;
    [self.view addSubview:self.recognitionView];
    
}

- (void)leftBarButtonItemAction {
    [self showViewController:[XRTodayHistoryViewController new] sender:nil];
}

- (void)settingAction {
    [self showViewController:[XRSettingViewController new] sender:nil];
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
                [self.view bringSubviewToFront:self.recognitionView];
                //开始捕获
                [self.sessionManager startRunning];

            });
        }];
    });
    
}

#pragma mark - RecognitionAction

- (void)recognitionAction:(UIImage *)image {
    
    self.recognitionView.reminderLabel.hidden = NO;
    self.recognitionView.reminderLabel.text = @"识别中...";
    
    [XRBaiduYunApi recognitionImage:image classify:self.recognitionView.imageClassifyURL success:^(id responseDict) {
        [MBProgressHUD hideHUD];
        self.recognitionView.reminderLabel.hidden = YES;
        self.recognitionView.sureButton.userInteractionEnabled = YES;
        NSMutableArray<XRIdentifyResultsModel *> *dataArray = [NSArray yy_modelArrayWithClass:XRIdentifyResultsModel.class json:responseDict[@"result"]].mutableCopy;
        
        if (dataArray.count == 0 || (dataArray.count == 1 && [dataArray.firstObject.name hasPrefix:@"非"])) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"该物体不是%@，换个类别试试看！", self.recognitionView.imageClassifyString] time:3];
            return;
        }
        
        if (self.recognitionView.cancleButton.hidden && self.tempImage) {
            return;
        }
        
        XRRecognitionListViewController *listVC = [XRRecognitionListViewController new];
        listVC.title = [NSString stringWithFormat:@"%@ - AI 深度识别", self.recognitionView.imageClassifyString];
        listVC.dataArray = dataArray;
        [[UIViewController currentViewController] showViewController:listVC sender:nil];
        
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD hideHUD];
        self.recognitionView.reminderLabel.hidden = YES;
        self.recognitionView.sureButton.userInteractionEnabled = YES;
        [MBProgressHUD showError:@"识别失败，请检查网络连接"];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.tempImage = nil;
    
    [MBProgressHUD showMessage:@"识别中..."];
    [self recognitionAction:resultImage];
    
}

#pragma mark - ShootViewDelegateAction

/**
 摄像头切换
 */
- (void)switchAction {
    [self.sessionManager switchFrontAndBackCameras];
}

/**
 相册
 */
- (void)photosAction {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
         dispatch_async(dispatch_get_main_queue(),^{
            if (status != PHAuthorizationStatusAuthorized) {
                [self showAlertWithTitle:@"无法使用相册" message:@"为了选择照片识别，请前往设备中的【设置】>【隐私】>【照片】中允许识图相机使用" actionTitles:@[@"知道了", @"去设置"] actionHandler:^(NSInteger index) {
                    if (index == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url]) {
                            NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
                return;
            }
             UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
             pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
             pickerController.delegate = self;
             [self presentViewController:pickerController animated:YES completion:nil];
        });
     }];
    
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
    
    if ([self.sessionManager isCanUseCamera]) {
        
        self.recognitionView.reminderLabel.text = @"取景中...";
        self.recognitionView.reminderLabel.hidden = NO;

        [self.sessionManager shootImage:^(UIImage *image) {
            [self.recognitionView shootComplete];
            [self.sessionManager stopRunning];
            self.tempImage = image;
            self.recognitionView.sureButton.userInteractionEnabled = NO;
            
            [self recognitionAction:image];
            
        }];
    }

}

/**
 取消重拍
 */
- (void)cancleAction {
    [self.sessionManager startRunning];
    self.recognitionView.reminderLabel.hidden = YES;
}

/**
 完成拍照
 */
- (void)sureAction {
    self.recognitionView.sureButton.userInteractionEnabled = NO;
    [self recognitionAction:self.tempImage];
}

/**
 插屏广告
 */
- (void)giftAction {
    [XRGADInterstitialApi.shared showInterstitialViewController:self];
}

@end
