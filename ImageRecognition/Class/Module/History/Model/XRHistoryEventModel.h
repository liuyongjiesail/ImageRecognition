//
//  XRHistoryEventModel.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XREventImageModel;

@interface XRHistoryEventModel : NSObject

@property (copy, nonatomic) NSString *eventId;
@property (copy, nonatomic) NSString *day;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *picNo;
@property (strong, nonatomic) NSArray<XREventImageModel *> *picUrl;

@end

@interface XREventImageModel : NSObject

@property (copy, nonatomic) NSString *pic_title;
@property (copy, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
