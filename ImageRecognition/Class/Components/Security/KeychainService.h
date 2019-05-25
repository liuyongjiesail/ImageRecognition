//
//  KeychainService.h
//  Store-Dev13
//
//  Created by Zhangziqi on 29/11/2016.
//  Copyright © 2016 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainService : NSObject

/**
 保存对象
 
 @param item 要保存的对象
 @param key 对象的Key
 */
+ (void)setItem:(id _Nonnull)item forKey:(NSString *_Nonnull)key;

/**
 取出保存的对象
 
 @param key 对象的Key
 @return 取出的对象
 */
+ (id _Nullable)itemForKey:(NSString *_Nonnull)key;

/**
 移除保存的对象
 
 @param key 对象的Key
 @return 是否移除成功
 */
+ (BOOL)removeItemForKey:(NSString *_Nonnull)key;

@end
