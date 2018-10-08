//
//  XREventListCell.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/8.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XREventListCell.h"
#import "XRHistoryEventModel.h"

@interface XREventListCell ()

@property (strong, nonatomic) UIView *timeLine;
@property (strong, nonatomic) UIView *timeCircle;
@property (strong, nonatomic) UIView *specLine;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation XREventListCell

- (void)setupViews {
    
    [self.contentView addSubview:self.timeLine];
    [self.contentView addSubview:self.timeCircle];
    [self.contentView addSubview:self.specLine];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.titleLabel];

    [self.timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kMarginHorizontal*1.5);
        make.width.mas_equalTo(3);
    }];
    
    [self.timeCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeLine);
        make.top.equalTo(self.contentView).offset(kMarginVertical);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.specLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeCircle);
        make.width.mas_equalTo(20);
        make.left.equalTo(self.timeCircle.mas_right).offset(kMarginHorizontal/4.0);
        make.height.mas_equalTo(1);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.specLine);
        make.left.equalTo(self.specLine.mas_right).offset(kMarginHorizontal/4.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.left.equalTo(self.dateLabel);
        make.right.equalTo(self.contentView).offset(-kMarginHorizontal*1.5);
    }];
}

- (void)configModelData:(XRHistoryEventModel *)model {
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@年", [model.date componentsSeparatedByString:@"年"].firstObject];
    self.titleLabel.text = model.title;
}

- (void)updateTimeLineTop:(CGFloat)top {
    [self.timeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(top);
    }];
}

#pragma mark - Lazy Loading
- (UIView *)timeLine {
    if (!_timeLine) {
        _timeLine = [UIView new];
        _timeLine.backgroundColor = [UIColor colorWithString:COLORFF3E3D];
    }
    return _timeLine;
}

- (UIView *)timeCircle {
    if (!_timeCircle) {
        _timeCircle = [UIView new];
        _timeCircle.backgroundColor = [UIColor whiteColor];
        _timeCircle.layer.cornerRadius = 5;
        _timeCircle.layer.borderWidth = 3;
        _timeCircle.layer.borderColor = [UIColor colorWithString:COLORFF3E3D].CGColor;
    }
    return _timeCircle;
}

- (UIView *)specLine {
    if (!_specLine) {
        _specLine = [UIView new];
        _specLine.backgroundColor = [UIColor colorWithString:COLORFF3E3D];
    }
    return _specLine;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel labWithText:@"2018" fontSize:18 textColorString:COLORFF3E3D];
        _dateLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _dateLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labWithText:@"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据" fontSize:18 textColorString:COLOR000000];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

@end
