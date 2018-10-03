//
//  UIColor+XRString.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "UIColor+XRString.h"

int convertToInt(char c)
{
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        return printf("字符非法！");
    }
}

@implementation UIColor (XRString)

+ (UIColor *)colorWithString:(NSString *)string {
    
    if (![[string substringToIndex:0] isEqualToString:@"#"] && string.length < 7) {
        return nil;
    }
    const char *str = [[string substringWithRange:NSMakeRange(1, 6)] UTF8String];
    NSString *alphaString = [string substringFromIndex:7];
    CGFloat red = (convertToInt(str[0]) * 16 + convertToInt(str[1])) / 255.0f;
    CGFloat green = (convertToInt(str[2]) * 16 + convertToInt(str[3])) / 255.0f;
    CGFloat blue = (convertToInt(str[4]) * 16 + convertToInt(str[5])) / 255.0f;
    CGFloat alpha = ([alphaString isEqualToString:@""]) ? 1 : alphaString.floatValue / 255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
