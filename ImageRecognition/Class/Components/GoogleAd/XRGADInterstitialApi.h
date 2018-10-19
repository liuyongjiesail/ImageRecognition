//
//  XRGADInterstitialApi.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/19.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRGADInterstitialApi : NSObject

+ (instancetype)shared;

- (void)showInterstitialViewController:(UIViewController *)viewController;

@end

