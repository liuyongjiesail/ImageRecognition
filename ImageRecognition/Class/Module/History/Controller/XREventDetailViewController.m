//
//  XREventDetailViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XREventDetailViewController.h"
#import "XRJuHeApi.h"
#import "XRHistoryEventModel.h"
#import "XREventDetailContentCell.h"
#import "XREventDetailImageCell.h"

@interface XREventDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation XREventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self fetchHistoryEventDetailInfo];
    
}

#pragma mark - CustomEvent

- (void)fetchHistoryEventDetailInfo {
    
    [XRJuHeApi fetchToadyDetailInfo:self.eventModel.eventId success:^(id responseDict) {
        
        XRHistoryEventModel *model = [NSArray yy_modelArrayWithClass:[XRHistoryEventModel class] json:responseDict[@"result"]].firstObject;
        NSString *tempString = self.eventModel.date;
        self.eventModel = model;
        self.eventModel.date = tempString;
        
        [self.tableView reloadData];
        
    } failure:^(NSInteger errorCode) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventModel.picNo.integerValue + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        XREventDetailContentCell *cell = [tableView xr_dequeueReusableCellWithClass:[XREventDetailContentCell class] forIndexPath:indexPath];
        [cell configModelData:self.eventModel];
        return cell;
    } else {
        XREventDetailImageCell *cell = [tableView xr_dequeueReusableCellWithClass:[XREventDetailImageCell class] forIndexPath:indexPath];
        [cell configModelData:self.eventModel.picUrl[indexPath.row - 1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(XREventDetailContentCell.class) cacheByIndexPath:indexPath configuration:^(XREventDetailContentCell *cell) {
            [cell configModelData:self.eventModel];
        }];
    } else {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(XREventDetailImageCell.class) configuration:^(XREventDetailImageCell *cell) {
            [cell configModelData:self.eventModel.picUrl[indexPath.row - 1]];
        }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(XREventDetailImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        [cell configModelData:self.eventModel.picUrl[indexPath.row - 1]];
    } 
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView xr_registerClass:[XREventDetailContentCell class]];
        [_tableView xr_registerClass:[XREventDetailImageCell class]];
    }
    return _tableView;
}

@end
