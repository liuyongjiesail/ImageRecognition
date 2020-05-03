//
//  MVGMWebViewController.h
//  MetaAppVideo
//
//  Created by 刘永杰 on 2020/3/4.
//  Copyright © 2020 MetaApp. All rights reserved.
//

#import "MVWebViewController.h"
#import "XRSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MVGMModel;

@interface MVGMWebViewController : MVWebViewController

+ (void)showGM:(XRItemModel *)model;

@end

NS_ASSUME_NONNULL_END
