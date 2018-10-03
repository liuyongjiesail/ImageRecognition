//
//  XRBaseView.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/1.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRBaseView.h"

@implementation XRBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {}

@end
