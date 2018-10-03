//
//  XRIdentifyResultsModel.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XRBaikeInfoModel;

@interface XRIdentifyResultsModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *root;
@property (copy, nonatomic) NSString *probability;
@property (strong, nonatomic) XRBaikeInfoModel *baike_info;

@end

@interface XRBaikeInfoModel : NSObject

@property (copy, nonatomic) NSString *baike_url;
@property (copy, nonatomic) NSString *image_url;
@property (copy, nonatomic) NSString *baike_description;

@end

NS_ASSUME_NONNULL_END
