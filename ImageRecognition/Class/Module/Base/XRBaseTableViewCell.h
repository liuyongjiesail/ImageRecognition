//
//  XRBaseTableViewCell.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRBaseTableViewCell : UITableViewCell

- (void)setupViews;

- (void)configModelData:(id)model;

@end

NS_ASSUME_NONNULL_END
