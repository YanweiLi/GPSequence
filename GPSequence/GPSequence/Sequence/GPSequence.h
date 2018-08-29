//
//  GPSeq.h
//  GPSequence
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////

#define GP_NEW_SEQ(...) \
[[GPSequence alloc] initWithOriginSequence:__VA_ARGS__]

#define GP_NEW_SEQ_WITH_TYPE(__type__, ...) \
((GPSequence<__type__> *)GP_NEW_SEQ(__VA_ARGS__))

//////////////////////////////////////////////////////////////////////

@protocol GPSTransfer;

NS_ASSUME_NONNULL_BEGIN

/**
 GPSequence 将所有可遍历的多级树，变换成一个只有叶子的数据结构
 */
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

