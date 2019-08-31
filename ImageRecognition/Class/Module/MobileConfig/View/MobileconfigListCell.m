//
//  TaskAdCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "MobileconfigListCell.h"
#import "KeychainService.h"

@interface MobileconfigListCell ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *recommendLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *priseImageView;
@property (strong, nonatomic) UILabel *downNumberLabel;
@property (strong, nonatomic) UIButton *downloadButton;

@end

@implementation MobileconfigListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //icon
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.backgroundColor = [UIColor whiteColor];
    iconImageView.layer.cornerRadius = 12;
    iconImageView.layer.masksToBounds = YES;
    _iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    
    //keyword
    UILabel *titleLabel = [UILabel labWithText:@"丝瓜视频网页版删除包" fontSize:16 textColorString:COLOR060606];
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    //是否推荐
    _recommendLabel = [UILabel labWithText:@"500次安装" fontSize:10 textColorString:COLORA9A9A9];
    [self.contentView addSubview:_recommendLabel];
    
    //subTitle
    _subTitleLabel = [UILabel labWithText:@"限免" fontSize:16 textColorString:@"#F35A21"];
    
    [self.contentView addSubview:_subTitleLabel];
    
    //星级
    _priseImageView = [UIImageView new];
    _priseImageView.image = [UIImage imageNamed:@"praise_wuxin"];
    [self.contentView addSubview:_priseImageView];
    
    //下载数
    _downNumberLabel = [UILabel labWithText:@"" fontSize:15 textColorString:COLORA9A9A9];
    [self.contentView addSubview:_downNumberLabel];
    
    // downloadButton
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton.backgroundColor = [UIColor colorWithString:@"#F35A21"];
    self.downloadButton.layer.cornerRadius = 4;
    self.downloadButton.layer.masksToBounds = YES;
    self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.downloadButton setTitle:@"解锁" forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.downloadButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.downloadButton];
    
    //line
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self.contentView addSubview:lineView];

    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(70);
        make.centerY.equalTo(self);
        
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImageView.mas_right).offset(11);
        make.top.equalTo(iconImageView).offset(2);
        
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        
    }];
    
    [self.priseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(iconImageView).offset(-2);
        
    }];
    
    [self.downNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.iconImageView);
        
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(self.downloadButton.titleLabel.mj_textWith + 30);
        
    }];
    
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downloadButton);
        make.top.equalTo(self.downloadButton.mas_bottom).offset(8);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        
    }];

}

- (void)setModel:(MobileconfigModel *)model {
    _model = model;
    
    self.titleLabel.text = model.appName;
    if (model.isFree) {
        self.subTitleLabel.text = @"限免";
        self.downloadButton.backgroundColor = [UIColor colorWithString:@"#23C66A"];
        [self.downloadButton setTitle:@"安装" forState:UIControlStateNormal];
    } else {
        self.subTitleLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
        if ([model.userIds containsObject:UIDevice.keychainIDFA] || [[KeychainService itemForKey:model.configId] isEqualToString:@"YES"]) {
            self.downloadButton.backgroundColor = [UIColor colorWithString:@"#23C66A"];
            [self.downloadButton setTitle:@"安装" forState:UIControlStateNormal];
        } else {
            self.downloadButton.backgroundColor = [UIColor colorWithString:@"#F35A21"];
            [self.downloadButton setTitle:@"解锁" forState:UIControlStateNormal];
        }
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.appIcon]];
    
    NSString *market = [NSString stringWithFormat:@"￥%@",model.originalPrice];
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:market];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,market.length)];
    self.downNumberLabel.attributedText = attributeMarket;
    
    self.downNumberLabel.hidden = (model.originalPrice.integerValue == model.price.integerValue);
    self.recommendLabel.text = @"安装即可删除";
    
}

- (void)buttonAction {
    if ([self.downloadButton.titleLabel.text isEqualToString:@"安装"]) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:self.model.downloadUrl]];
    } else {
        [ApplePayComponent.sharedInstance purchase:self.model.productId success:^{
            [MBProgressHUD showSuccess:@"你已成功解锁，请去安装"];
            [KeychainService setItem:@"YES" forKey:self.model.configId];
            self.model = self.model;
        } failure:^(NSString * _Nonnull error) {
            [MBProgressHUD showError:error];
        }];
    }
}

@end
