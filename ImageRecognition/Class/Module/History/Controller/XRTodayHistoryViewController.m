//
//  XRHomeViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/29.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRTodayHistoryViewController.h"
#import "XRJuHeApi.h"
#import "XRHistoryEventModel.h"
#import "XREventDetailViewController.h"
#import "XRRecognitionViewController.h"
#import "XREventListCell.h"

@interface XRTodayHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation XRTodayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    
    [self.view addSubview:self.tableView];
    self.title = [NSString stringWithFormat:@"历史上%@都发生了什么", [NSDate wholeToday]];
    
    [self fetchToadyOnHistory];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort"] style:UIBarButtonItemStyleDone target:self action:@selector(sortAction)];
    
}

#pragma mark - CustomEvent

- (void)fetchToadyOnHistory {
    
    self.dataArray = [NSMutableArray array];
    
    [XRJuHeApi fetchToadyOnHistory:[NSDate today] success:^(id responseDict) {
        
        self.dataArray = [[[NSArray yy_modelArrayWithClass:[XRHistoryEventModel class] json:responseDict[@"result"]] reverseObjectEnumerator] allObjects].mutableCopy;
        [self.tableView reloadData];
        
    } failure:^(NSInteger errorCode) {
        
    }];
    
}

- (void)sortAction {
    
    self.dataArray = [[self.dataArray reverseObjectEnumerator] allObjects].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XREventListCell *cell = [tableView xr_dequeueReusableCellWithClass:[XREventListCell class] forIndexPath:indexPath];
    XRHistoryEventModel *model = self.dataArray[indexPath.row];
    [cell configModelData:model];
    
    if (indexPath.row == 0) {
        [cell updateTimeLineTop:kMarginVertical];
    } else {
        [cell updateTimeLineTop:0];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XREventDetailViewController *detailVC = [XREventDetailViewController new];
    detailVC.eventModel = self.dataArray[indexPath.row];
    [self showViewController:detailVC sender:nil];
    
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView xr_registerClass:[XREventListCell class]];
    }
    return _tableView;
}

@end
