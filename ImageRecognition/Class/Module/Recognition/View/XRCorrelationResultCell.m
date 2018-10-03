//
//  XRCorrelationResultCell.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRCorrelationResultCell.h"

@implementation XRCorrelationResultCell

- (void)setupViews {
    [super setupViews];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:16];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kMarginVertical);
        make.left.equalTo(self.contentView).offset(kMarginHorizontal);
        make.width.height.mas_equalTo(110);
        make.bottom.equalTo(self.contentView).offset(-kMarginVertical);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView).offset(kMarginVertical/2.0);
        make.left.equalTo(self.contentImageView.mas_right).offset(kMarginHorizontal/1.5);
        make.right.equalTo(self.contentView.mas_right).offset(-kMarginHorizontal);
    }];
    
    [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kMarginVertical/2.0);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(kMarginVertical/2.0);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-kMarginHorizontal);
        make.bottom.equalTo(self.contentImageView).offset(-kMarginVertical/2.0);
    }];
}

@end
