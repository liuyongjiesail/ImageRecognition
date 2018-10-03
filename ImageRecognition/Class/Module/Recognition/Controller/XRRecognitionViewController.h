//
//  XRRecognitionViewController.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/1.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockImage)(UIImage *image);

@interface XRRecognitionViewController : UIViewController

@property (copy, nonatomic) BlockImage blcokImage;

@end

NS_ASSUME_NONNULL_END
