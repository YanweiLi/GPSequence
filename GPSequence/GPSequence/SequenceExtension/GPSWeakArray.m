//
//  GPSWeakArray.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSWeakArray.h"
#import "GPSequence+Operations.h"
#import "GPSUsefulBlocks.h"
#import "GPMarcoDefine.h"
#import "GPSWeakReference.h"

@implementation GPSWeakArray

- (instancetype) initWithNSArray:(NSArray *)array
{
    NSParameterAssert(array);
    if (self = [super initWithNSArray:@[]]) {
        for (id item in array) {
            [self addObject:item];
        }
    }
    
    return self;
}

#pragma mark -  get methods

- (nullable id) objectAtIndex:(NSUInteger)index
{
    GPSWeakReference *obj = [super objectAtIndex:index];
    return obj.reference;
}

#pragma mark - add methods

- (void) insertObject:(id)anObject
              atIndex:(NSUInteger)index
{
    GPSWeakReference *obj = [self weakReference:anObject];
    [super insertObject:obj atIndex:index];
}

#pragma mark - replace methods

- (void) setObject:(id)anObject
atIndexedSubscript:(NSUInteger)idx
{
    GPSWeakReference *obj = [self weakReference:anObject];
    [super setObject:obj atIndexedSubscript:idx];
}

#pragma mark - fastEnumeation

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state
                                   objects:(id  _Nullable __unsafe_unretained [])buffer
                                     count:(NSUInteger)len
{
    __autoreleasing NSArray *array = self.toArray;
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id) copyWithZone:(NSZone *)zone
{
    GPSWeakArray *newArray = [[[self class] allocWithZone:zone] init];
    for (id item in self) {
        [newArray addObject:item];
    }
    return newArray;
}

#pragma mark - EZSTransfer Protocol

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    GPSWeakArray *array = [[GPSWeakArray alloc] init];
    [sequence forEach:^(id  _Nonnull item) {
        [array addObject:item];
    }];
    return array;
}

- (NSArray *) toArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    // 新建一个weak reference 对象，加入到数组中
    for (GPSWeakReference *reference in [super toArray]) {
        id strongItem = reference.reference;
        if (strongItem) {
            [array addObject:strongItem];
        }
    }
    
    return array;
}

- (GPSWeakReference *) weakReference:(id _Nonnull)anObject
{
    __weak typeof(self) weakSelf = self;
    return [[GPSWeakReference alloc] initWithReference:anObject
                                          deallocBlock:^(GPSWeakReference * _Nonnull ref) {
                                              __strong typeof(weakSelf) self = weakSelf;
                                              [self removeObject:ref];
                                          }];
}
@end
