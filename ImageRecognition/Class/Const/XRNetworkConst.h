//
//  XRNetworkConst.h
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/29.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#ifndef XRNetworkConst_h
#define XRNetworkConst_h

#pragma mark - JuHe

static NSString * const juheTodayOnHistoryURL = @"http://v.juhe.cn/todayOnhistory/queryEvent.php";
static NSString * const juheEventDetailURL    = @"http://v.juhe.cn/todayOnhistory/queryDetail.php";

#pragma mark - BaiduYun

static NSString * const baiduYunDomain            = @"https://aip.baidubce.com";

/// Token相关
static NSString * const baiduYunOauth             = @"oauth";
static NSString * const baiduYunToken             = @"2.0/token";

/// 图像识别相关
static NSString * const baiduYunImageClassify     = @"rest/2.0/image-classify";

static NSString * const baiduYunClassifyGeneral   = @"v2/advanced_general";
static NSString * const baiduYunClassifyDish      = @"v2/dish";
static NSString * const baiduYunClassifyCar       = @"v1/car";
static NSString * const baiduYunClassifyAnimal    = @"v1/animal";
static NSString * const baiduYunClassifyPlant     = @"v1/plant";
static NSString * const baiduYunClassifyLogo      = @"v2/logo";

static NSString * const baiduYunClassifyObject    = @"v1/object_detect";

#endif /* XRNetworkConst_h */
