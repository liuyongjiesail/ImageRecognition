//
//  XRSettingViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/3.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRSettingViewController.h"
#import "XRWebViewController.h"
#import "XRMobileConfigListController.h"
#import "XRMobileconfigApi.h"
#import "XRGADBannerApi.h"
#import "XRGameViewController.h"

@interface XRSettingViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) XRGADBannerApi *bannerApi;

@end

@implementation XRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    self.dataArray = @[@[@"分享给好友"], @[@"帮助与反馈", @"去评分"], @[@"用户协议", @"关于"], @[@"去除广告", @"打赏开发者"]].mutableCopy;
    
    [self.view addSubview:self.tableView];
    
    //添加广告
    [self.bannerApi loadBannerAdView:self];
    
    [XRMobileconfigApi fetchInreviewConfigSuccess:^(id responseDict) {
        if (![responseDict[@"version"] containsObject:NSBundle.appVersionNumber]) {
            [self.dataArray addObject:@[@"娱乐专区"]];
            [self.dataArray addObject:@[@"流氓软件删除破解专区"]];
            [self.tableView reloadData];
        }
    } failure:^(NSInteger errorCode) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [UIApplication.sharedApplication shareApplicationToFriends];
                    break;
                }
                case 1: {
                    break;
                }
            }
            break;
        } case 1: {
            switch (indexPath.row) {
                case 0: {
                    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                    pboard.string = @"738874700";
                    [self showAlertWithTitle:[NSString stringWithFormat:@"如果您有意见和建议，欢迎加入qq群反馈：\n\n群号码：738874700"] message:@"已复制到剪切板" actionTitles:@[@"好的"] actionHandler:nil];
                    break;
                }
                case 1: {
                    [UIApplication.sharedApplication commentApplicationToAppStore];
                    break;
                }
            }
            break;
        } case 2: {
            switch (indexPath.row) {
                case 0: {
                    NSString* path = [[NSBundle mainBundle] pathForResource:@"user_protocol" ofType:@"html"];
                    XRWebViewController *webVC = [XRWebViewController new];
                    webVC.urlString = path;
                    [self showViewController:webVC sender:nil];
                    break;
                }
                case 1: {
                    [self showAlertWithTitle:[NSString stringWithFormat:@"《%@》\n\n版本号 %@", NSBundle.appName, NSBundle.appVersion] message:@"" actionTitles:@[@"好的"] actionHandler:nil];
                    break;
                }
            }
            break;
        } case 3: {
            if (indexPath.row == 0) {
                [XRGADInterstitialApi.shared removeAds];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"期待您的打赏" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"3颗糖果(3元)", @"6颗糖果(6元)", @"12颗糖果(12元)", @"18颗糖果(18元)", @"25颗糖果(25元)", nil];
                alertView.delegate = self;
                [alertView show];
            }
            break;
        } case 4: {
            [self showViewController:XRGameViewController.new sender:nil];
            break;
        } case 5: {
            [self showViewController:XRMobileConfigListController.new sender:nil];
            break;
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [ApplePayComponent.sharedInstance purchase:[self tempArray][buttonIndex] success:^{
            [MBProgressHUD showSuccess:@"感谢您的打赏"];
        } failure:^(NSString * _Nonnull error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:error time:2];
            });
        }];
    }
}

- (NSArray *)tempArray {
    return @[@"", @"com.sail.xrecognition.release.3", @"com.sail.xrecognition.release.6", @"com.sail.xrecognition.release.12", @"com.sail.xrecognition.release.18", @"com.sail.xrecognition.release.25"];
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 20;
        _tableView.sectionFooterHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    }
    return _tableView;
}

- (XRGADBannerApi *)bannerApi {
    if (!_bannerApi) {
        _bannerApi = XRGADBannerApi.new;
    }
    return _bannerApi;
}

@end
