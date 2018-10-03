//
//  NSDate+XRTimestamp.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/9/30.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "NSDate+XRTimestamp.h"

@implementation NSDate (XRTimestamp)

+ (NSString *)wholeToday {
    return [self stringFromDate:[NSDate date] formatStr:@"MM月dd日"];
}

+ (NSString *)today {
    return [self stringFromDate:[NSDate date] formatStr:@"M/d"];
}

+ (NSString *)stringFromDate:(NSDate *)date formatStr:(NSString *)formatStr {
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:formatStr];
    
    NSString *dateStr = [dateformatter stringFromDate:date];
    
    return dateStr;
}

@end
