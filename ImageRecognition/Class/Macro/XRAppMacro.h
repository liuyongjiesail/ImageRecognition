//
//  XRAppMacro.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/29.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#ifndef XRAppMacro_h
#define XRAppMacro_h

// 自定义NSLog,在debug模式下打印，在release模式下取消一切NSLog
#ifdef DEBUG
#define XRLog(FORMAT, ...) fprintf(stderr,"<%s:%d>:\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define XRLog(FORMAT, ...) nil
#endif

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds

#define SAFEAREINSETS ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = UIApplication.sharedApplication.keyWindow.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#endif /* XRAppMacro_h */
