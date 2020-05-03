//
//  UINavigationBar+FixSpace.m
//  MetaAppEdition
//
//  Created by 刘永杰 on 2019/11/2.
//  Copyright © 2019 北京展心展力信息科技有限公司. All rights reserved.
//

#import "UINavigationBar+FixSpace.h"
#import <objc/runtime.h>
#import "UIView+Frame.h"

@implementation UINavigationBar (FixSpace)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // layoutSubviews
        Method originalAppearMethod = class_getInstanceMethod(class, @selector(layoutSubviews));
        Method swizzledAppearMethod = class_getInstanceMethod(class, @selector(mx_layoutSubviews));
        method_exchangeImplementations(originalAppearMethod, swizzledAppearMethod);
        
    });
}

- (void)mx_layoutSubviews {
    [self mx_layoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        if (@available(iOS 13.0, *)) {
            for (UIView *view in self.subviews) {
                if ([NSStringFromClass(view.class) containsString:@"ContentView"]) {
                    UIEdgeInsets margins = view.layoutMargins;
                    CGRect frame = view.frame;
                    frame.origin.x = -margins.left;
                    frame.origin.y = -margins.top;
                    frame.size.width += (margins.left + margins.right) - 15;
                    frame.size.height += (margins.top + margins.bottom);
                    view.frame = frame;
                }
            }
        } else {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 15);
            for (UIView *subview in self.subviews) {
                if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                    subview.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 15);
                }
            }
        }
    } else {
        for (UIButton *button in self.subviews) {
            if (![button isKindOfClass:[UIButton class]]) continue;
            if (button.centerX < self.width * 0.5) {
                button.x = 0;
            }
        }
    }
    
}

@end
