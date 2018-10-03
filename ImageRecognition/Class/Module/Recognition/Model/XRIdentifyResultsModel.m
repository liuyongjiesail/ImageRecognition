//
//  XRIdentifyResultsModel.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRIdentifyResultsModel.h"

@implementation XRIdentifyResultsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baike_info" : [XRBaikeInfoModel class]};
}

@end

@implementation XRBaikeInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"baike_description":@"description"};
}

@end
