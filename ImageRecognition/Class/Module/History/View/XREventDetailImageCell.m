//
//  XREventDetailImageCell.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XREventDetailImageCell.h"
#import "XRHistoryEventModel.h"

@interface XREventDetailImageCell ()

@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation XREventDetailImageCell

- (void)setupViews {
    
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kMarginHorizontal);
        make.width.mas_equalTo(SCREEN_WIDTH - 2*kMarginHorizontal);
        make.height.mas_equalTo(100);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(kMarginVertical/2.0);
        make.left.equalTo(self.contentView).offset(3*kMarginHorizontal);
        make.right.equalTo(self.contentView).offset(-3*kMarginHorizontal);
        make.bottom.equalTo(self.contentView).offset(-kMarginHorizontal*2);
    }];
}

- (void)configModelData:(XREventImageModel *)model {
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(image.size.height * (SCREEN_WIDTH - 2*kMarginHorizontal) / image.size.width);
        }];
        
    }];
    
    if (model.pic_title && model.pic_title.length != 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"△ %@", model.pic_title];
    } else {
        self.titleLabel.text = @"";
    }
    
}

#pragma mark - Lazy Loading

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.masksToBounds = YES;
    }
    return _contentImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labWithText:@"" fontSize:14 textColorString:COLOR888888];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
