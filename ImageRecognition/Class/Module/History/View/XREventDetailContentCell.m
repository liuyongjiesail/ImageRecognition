//
//  XREventDetailContentCell.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XREventDetailContentCell.h"
#import "XRHistoryEventModel.h"

@interface XREventDetailContentCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation XREventDetailContentCell

- (void)setupViews {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kMarginVertical);
        make.left.equalTo(self.contentView).offset(kMarginHorizontal);
        make.right.equalTo(self.contentView).offset(-kMarginHorizontal);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kMarginVertical);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMarginHorizontal);
        make.right.equalTo(self.contentView).offset(-kMarginHorizontal);        make.top.equalTo(self.dateLabel.mas_bottom).offset(2*kMarginVertical);
        make.width.mas_equalTo(SCREEN_WIDTH - 2*kMarginVertical);
        make.bottom.equalTo(self.contentView).offset(-kMarginVertical);
    }];
    
}

- (void)configModelData:(XRHistoryEventModel *)model {
    
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.date;
    self.contentLabel.text = model.content;
    
    [self.titleLabel setLineSpacing:3];
    [self.contentLabel setLineSpacing:8];
    
}

#pragma mark - Lazy Loading

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labWithText:@"" fontSize:26 textColorString:COLOR000000];
        _titleLabel.font = [UIFont boldSystemFontOfSize:24];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel labWithText:@"" fontSize:16 textColorString:COLORACACAC];
        _dateLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _dateLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel labWithText:@"" fontSize:18 textColorString:COLOR000000];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
