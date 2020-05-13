//
//  XRRecognitionListViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRRecognitionListViewController.h"
#import "XRBestResultCell.h"
#import "XRCorrelationResultCell.h"
#import "XRIdentifyResultsModel.h"
#import "XRWebViewController.h"

@interface XRRecognitionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) XRGADBannerApi *bannerApi;

@end

@implementation XRRecognitionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    //添加广告
    [self.bannerApi loadBannerAdView:self];
    
    //随机弹出评价
    if (![NSUserDefaults.standardUserDefaults objectForKey:@"NewComment"]) {
        [NSUserDefaults.standardUserDefaults setObject:@"1" forKey:@"NewComment"];
        [NSUserDefaults.standardUserDefaults synchronize];
        [UIApplication.sharedApplication commentApplicationToAppStore];
    }
    
}

- (void)shareAction {
    
    [UIApplication.sharedApplication shareApplicationToFriends];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        XRBestResultCell *cell = [tableView xr_dequeueReusableCellWithClass:[XRBestResultCell class] forIndexPath:indexPath];
        [cell configModelData:self.dataArray[indexPath.row]];
        return cell;
    } else {
        XRCorrelationResultCell *cell = [tableView xr_dequeueReusableCellWithClass:[XRCorrelationResultCell class] forIndexPath:indexPath];
        [cell configModelData:self.dataArray[indexPath.row]];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(XRBestResultCell.class)  configuration:^(XRBestResultCell *cell) {
            [cell configModelData:self.dataArray[indexPath.row]];
        }];
    } else {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(XRCorrelationResultCell.class)  configuration:^(XRCorrelationResultCell *cell) {
            [cell configModelData:self.dataArray[indexPath.row]];
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XRWebViewController *webVC = [XRWebViewController new];
    XRIdentifyResultsModel *model = self.dataArray[indexPath.row];
    webVC.urlString = model.baike_info.baike_url;
    if (!model.baike_info.baike_url && model.baike_info.baike_url.length == 0) {
        webVC.urlString = [NSString stringWithFormat:@"https://baidu.com"];
        UIPasteboard *past = [UIPasteboard generalPasteboard];
        if (model.name) {
            past.string = model.name;
        }
        if (model.keyword) {
            past.string = model.keyword;
        }
        [MBProgressHUD showError:@"关键字复制成功\n请直接粘贴后，自行搜索" time:5];
    }
    [self showViewController:webVC sender:nil];
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [_tableView xr_registerClass:[XRBestResultCell class]];
        [_tableView xr_registerClass:[XRCorrelationResultCell class]];
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
