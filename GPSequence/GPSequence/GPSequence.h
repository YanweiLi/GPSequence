//
//  GPSeq.h
//  GPSequence
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GPSTransfer;

NS_ASSUME_NONNULL_BEGIN

@interface GPSequence <T> : NSObject<NSFastEnumeration>

/**
 默认初始化函数

 @param originSequence 快速枚举对象
 @return GPSequence 实例
 */
- (instancetype)initWithOriginSequence:(id<NSFastEnumeration>)originSequence NS_DESIGNATED_INITIALIZER;

/**
 转换为 GPSTransfer 对应的实例

 @param clazz GPSTransfer 实例
 @return 转换后的类型
 */
- (id)as:(Class<GPSTransfer>)clazz;

- (void)forEachWithIndexAndStop:(void (NS_NOESCAPE ^)(T item, NSUInteger index, BOOL *stop))eachBlock;

- (NSEnumerator<T> *)objectEnumerator;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
