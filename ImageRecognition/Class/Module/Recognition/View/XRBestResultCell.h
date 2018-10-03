//
//  XRBestResultCell.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRBestResultCell : XRBaseTableViewCell

@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END
