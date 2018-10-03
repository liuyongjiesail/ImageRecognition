//
//  XRHomeViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/29.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRHomeViewController.h"
#import "XRJuHeApi.h"
#import "XRHistoryEventModel.h"
#import "XREventDetailViewController.h"
#import "XRRecognitionViewController.h"

@interface XRHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation XRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    
    [self.view addSubview:self.tableView];
    self.title = [NSDate wholeToday];
    
    [self fetchToadyOnHistory];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView xr_dequeueReusableCellWithClass:[UITableViewCell class] forIndexPath:indexPath];
    XRHistoryEventModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.date;
    
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
        [_tableView xr_registerClass:[UITableViewCell class]];
    }
    return _tableView;
}

@end
