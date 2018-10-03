//
//  UILabel+XRInitialize.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XRInitialize)

+ (UILabel *)labWithText:(NSString *)text fontSize:(CGFloat)fontSize textColorString:(NSString *)textColorString;

- (void)setLineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
