//
//  ShootView.h
//  DynamicPublic
//
//  Created by 刘永杰 on 2017/7/27.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRBaseView.h"

@protocol XRRecognitionViewDelegate <NSObject>

- (void)shootAction;
- (void)photosAction;
- (void)cancleAction;
- (void)sureAction;
- (void)focusingActionAtPoint:(CGPoint)point;

@end

@interface XRRecognitionView : XRBaseView

@property (weak, nonatomic) id<XRRecognitionViewDelegate> delegate;
@property (copy, nonatomic) NSString *imageClassifyString;
@property (copy, nonatomic) NSString *imageClassifyURL;

//拍照完成
- (void)shootComplete;

@end
