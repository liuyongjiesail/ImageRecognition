//
//  UILabel+XRInitialize.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "UILabel+XRInitialize.h"

@implementation UILabel (XRInitialize)

+ (UILabel *)labWithText:(NSString *)text fontSize:(CGFloat)fontSize textColorString:(NSString *)textColorString {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithString:textColorString];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    return label;
    
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    
    if (self.text == nil) {
        return;
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
    
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

@end
