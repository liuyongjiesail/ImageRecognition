//
//  XRSectionModel.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2020/4/30.
//  Copyright © 2020 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MXItemType) {
    MXItemTypeLinks         = 0,
    MXItemTypeGameLinks     = 1,
    MXItemTypeGameShandw    = 2,
    MXItemTypeAds           = 3,
};

@class XRItemModel;

@interface XRSectionModel : NSObject

@property (copy, nonatomic) NSString *largeTitle;
@property (copy, nonatomic) NSString *moreTile;
@property (copy, nonatomic) NSString *moreUrl;

@property (strong, nonatomic) NSArray<XRItemModel *> *items;

@end

@interface XRItemModel : NSObject

@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *itemUrl;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *name;
// 是否是横屏
@property (assign, nonatomic) BOOL isLandscape;
// 游戏类型 others, shandianwan
@property (assign, nonatomic) MXItemType type;

@property (assign, nonatomic) NSInteger delayTime;

@end

NS_ASSUME_NONNULL_END
