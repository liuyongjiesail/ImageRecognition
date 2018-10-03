//
//  UITableView+XRRegister.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "UITableView+XRRegister.h"

@implementation UITableView (XRRegister)

- (void)xr_registerClass:(Class)cls {
    [self registerClass:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}

- (__kindof UITableViewCell *)xr_dequeueReusableCellWithClass:(Class)cls forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cls) forIndexPath:indexPath];
}

@end
