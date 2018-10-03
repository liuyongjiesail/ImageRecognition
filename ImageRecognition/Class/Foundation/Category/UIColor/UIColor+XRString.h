//
//  UIColor+XRString.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XRString)

//以#开头的字符串（不区分大小写）,如：#ffFFff, 若需要alpha，则传#abcdef255, 不传默认为1
+ (UIColor *)colorWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
