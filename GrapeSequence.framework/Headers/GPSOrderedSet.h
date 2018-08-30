//
//  GPSOrderedSet.h
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSTransfer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 线程安全的容器
 */
@interface GPSOrderedSet <__covariant T> : NSObject <NSFastEnumeration, NSCopying, GPSTransfer>

@property (readonly , atomic) NSUInteger count;

- (instancetype)initWithNSArray:(NSArray<T> *)array;
- (instancetype)initWithNSOrderedSet:(NSOrderedSet<T> *)set NS_DESIGNATED_INITIALIZER;

- (T)objectAtIndex:(NSUInteger)index;
- (void)addObject:(T)anObject;
- (void)insertObject:(T)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeFirstObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeObject:(T)anObject;
- (void)removeAllObjects;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(T)anObject;

- (NSArray<T> *)allObjects;

- (void)setObject:(T)obj atIndexedSubscript:(NSUInteger)idx;
- (T)objectAtIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
