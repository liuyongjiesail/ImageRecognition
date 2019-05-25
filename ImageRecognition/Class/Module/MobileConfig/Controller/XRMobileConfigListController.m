//
//  XRMobileConfigListController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/5/22.
//  Copyright © 2019 刘永杰. All rights reserved.
//

#import "XRMobileConfigListController.h"
#import "MobileconfigListCell.h"
#import "XRMobileconfigApi.h"
#import "MobileconfigModel.h"
#import "XRHelpViewController.h"

@interface XRMobileConfigListController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView      *footerView;

@property (strong, nonatomic) NSMutableArray<NSArray<MobileconfigModel *> *> *dataArray;

@end

@implementation XRMobileConfigListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"如何解锁?" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [XRMobileconfigApi fetchMobileconfigListSuccess:^(id responseDict) {
            [self.tableView.mj_header endRefreshing];
            self.dataArray = [NSMutableArray array];
            [responseDict[@"list"] enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataArray addObject:[NSArray yy_modelArrayWithClass:MobileconfigModel.class json:obj]];
            }];
            [self.tableView reloadData];
        } failure:^(NSInteger errorCode) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)rightAction {
    [self showViewController:XRHelpViewController.new sender:nil];
}

- (void)copyAction {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = UIDevice.keychainIDFA;
    [MBProgressHUD showSuccess:@"复制成功"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MobileconfigListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configModelData:self.dataArray[indexPath.section][indexPath.row] indexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section].firstObject.title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [_tableView registerClass:MobileconfigListCell.class forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - SAFEAREINSETS.bottom, SCREEN_WIDTH, 49 + SAFEAREINSETS.bottom)];
        _footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *titleLabel = [UILabel labWithText:[NSString stringWithFormat:@"我的ID:%@", UIDevice.keychainIDFA] fontSize:14 textColorString:COLOR000000];
        titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [_footerView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_footerView).offset(10);
            make.centerY.equalTo(self->_footerView).offset(-SAFEAREINSETS.bottom/2.0);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"复制" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithString:COLOR333333];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->_footerView).offset(-10);
            make.centerY.equalTo(titleLabel);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
    }
    return _footerView;
}

@end
