//
//  XRGameViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/3/21.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import "XRGameViewController.h"
#import "XRSectionTitleView.h"
#import "XRSectionModel.h"
#import "XRMobileconfigApi.h"
#import "XRGameCell.h"
#import "XRWebViewController.h"
#import "MVGMWebViewController.h"

@interface XRGameViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) XRGADBannerApi *bannerApi;

@property (strong, nonatomic) NSMutableArray<XRSectionModel *> *dataArray;

@end

@implementation XRGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"免费资源(全网聚合)";
    
    [self.view addSubview:self.collectionView];
    [self.bannerApi loadBannerAdView:self];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [XRMobileconfigApi fetchGameListSuccess:^(id responseDict) {
            self.dataArray = [NSArray yy_modelArrayWithClass:XRSectionModel.class json:responseDict[@"data"]].mutableCopy;
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            
        } failure:^(NSInteger errorCode) {
            [self.collectionView.mj_header endRefreshing];
        }];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    
}

#pragma mark - CollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XRGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(XRGameCell.class) forIndexPath:indexPath];
    XRItemModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    cell.titleLabel.text = model.name;
    return cell;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    XRSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader){
        XRSectionTitleView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(XRSectionTitleView.class) forIndexPath:indexPath];
        titleView.titleLabel.text = sectionModel.largeTitle;
        return titleView;
    } else {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        footer.backgroundColor = HEX(0xF5F5F5);
        return footer;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 80);
    }
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XRItemModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    if (model.type == MXItemTypeLinks) {
        [MVWebViewController showWebURL:model.itemUrl];
    } else if (model.type == MXItemTypeAds) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:model.itemUrl]];
    } else {
        [MVGMWebViewController showGM:model];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 24;
        CGFloat width = (SCREEN_WIDTH - 24*5)/4.0;
        layout.itemSize = CGSizeMake(width, width*1.8);
        layout.sectionInset = UIEdgeInsetsMake(0, 24, 0, 24);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:XRGameCell.class forCellWithReuseIdentifier:NSStringFromClass(XRGameCell.class)];
        [_collectionView registerClass:XRSectionTitleView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(XRSectionTitleView.class)];
        [_collectionView registerClass:XRSectionTitleView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
    }
    return _collectionView;
}

- (XRGADBannerApi *)bannerApi {
    if (!_bannerApi) {
        _bannerApi = XRGADBannerApi.new;
    }
    return _bannerApi;
}

- (NSMutableArray<XRSectionModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end
