//
//  XRHistoryEventModel.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRHistoryEventModel.h"

@implementation XRHistoryEventModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"eventId":@"e_id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picUrl" : [XREventImageModel class]};
}

@end

@implementation XREventImageModel

@end
