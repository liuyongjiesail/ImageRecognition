//
//  XRGameCell.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/4/30.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import "XRGameCell.h"

@implementation XRGameCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo((SCREEN_WIDTH - 24*5)/4.0);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    
}

#pragma mark - Lazy Loading

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = UIImageView.new;
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = HEX(0x212529);
    }
    return _titleLabel;
}

@end
