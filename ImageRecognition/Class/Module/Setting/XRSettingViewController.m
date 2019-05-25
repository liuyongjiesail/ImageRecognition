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

@interface XRSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation XRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    self.dataArray = @[@[@"分享给好友"], @[@"帮助与反馈", @"去评分"], @[@"用户协议", @"关于"]].mutableCopy;
    
    [self.view addSubview:self.tableView];
    
    [XRMobileconfigApi fetchInreviewConfigSuccess:^(id responseDict) {
        if (![responseDict[@"version"] containsObject:NSBundle.appVersionNumber]) {
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
            [self showViewController:XRMobileConfigListController.new sender:nil];
            break;
        }
    }
    
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

@end
