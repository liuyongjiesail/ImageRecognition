//
//  XREventDetailViewController.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRHistoryEventModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XREventDetailViewController : UIViewController

@property (strong, nonatomic) XRHistoryEventModel *eventModel;

@end

NS_ASSUME_NONNULL_END
