//
//  XRSectionTitleView.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/3/22.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import "XRSectionTitleView.h"

@implementation XRSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = HEX(0x1B1B1B);
    }
    return _titleLabel;
}

@end
