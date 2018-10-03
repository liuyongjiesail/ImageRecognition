//
//  XRBestResultCell.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRBestResultCell.h"
#import "XRIdentifyResultsModel.h"

@interface XRBestResultCell ()

@end

@implementation XRBestResultCell

- (void)setupViews {
    
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kMarginHorizontal);
        make.left.equalTo(self.contentView).offset(kMarginHorizontal);
        make.width.height.mas_equalTo(SCREEN_WIDTH - 2*kMarginHorizontal);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(kMarginVertical);
        make.left.equalTo(self.contentImageView);
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentImageView);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kMarginVertical);
        make.left.equalTo(self.contentView).offset(kMarginHorizontal);
        make.right.equalTo(self.contentView).offset(-kMarginHorizontal);
        make.bottom.equalTo(self.contentView).offset(-kMarginHorizontal);
    }];
    
}

- (void)configModelData:(XRIdentifyResultsModel *)model {
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.baike_info.image_url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    self.titleLabel.text = model.name;
    if (!model.name && model.name.length == 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", model.keyword, model.root];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"可信度：%.0f%%", model.score.floatValue*100];
    if (!model.score && model.score.length == 0) {
        self.scoreLabel.text = [NSString stringWithFormat:@"可信度：%.0f%%", model.probability.floatValue*100];
    }
    self.descriptionLabel.text = model.baike_info.baike_description;
    
    [self.descriptionLabel setLineSpacing:3];
}

#pragma mark - Lazy Loading

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.masksToBounds = YES;
        self.contentImageView.layer.cornerRadius = 6;
    }
    return _contentImageView;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [UILabel labWithText:@"" fontSize:20 textColorString:COLORFF3E3D];
        _scoreLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _scoreLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labWithText:@"" fontSize:22 textColorString:COLOR000000];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel labWithText:@"" fontSize:16 textColorString:COLOR979AA0];
    }
    return _descriptionLabel;
}

@end
