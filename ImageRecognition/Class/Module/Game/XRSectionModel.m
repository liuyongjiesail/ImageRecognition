//
//  XRSectionModel.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/4/30.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import "XRSectionModel.h"

@implementation XRSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"items" : [XRItemModel class]};
}

@end

@implementation XRItemModel

@end
