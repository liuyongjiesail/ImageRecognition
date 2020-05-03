//
//  XRTextViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/5/3.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import "XRTextViewController.h"

@interface XRTextViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation XRTextViewController

+ (void)showTextImage:(UIImage *)image textArray:(NSArray *)textArray {
    XRTextViewController *textVC = XRTextViewController.new;
    textVC.imageView.image = image;
    textVC.dataArray = textArray;
    [UIViewController.currentViewController showViewController:textVC sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:UIImage.new];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_WIDTH*0.65);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom);
    }];
    
    [XRGADInterstitialApi.shared showInterstitialViewController:self completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.dataArray[indexPath.row][@"words"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.dataArray[indexPath.row][@"words"];
    [MBProgressHUD showSuccess:@"复制成功"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = UIColor.blackColor;
    }
    return _imageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
