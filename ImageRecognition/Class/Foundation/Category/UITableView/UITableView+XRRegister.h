//
//  UITableView+XRRegister.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (XRRegister)

- (void)xr_registerClass:(Class)cls;

- (__kindof UITableViewCell *)xr_dequeueReusableCellWithClass:(Class)cls forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
