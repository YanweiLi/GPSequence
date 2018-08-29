//
//  GPSArray.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSArray.h"
#import "GPSequence+Operations.h"
#import "GPSUsefulBlocks.h"
#import "GPMarcoDefine.h"

@implementation GPSArray
{
    NSMutableArray *_mutableArray;
    GPS_LOCK_DEF(_arrayLock);
}

- (instancetype) init
{
    return [self initWithNSArray:@[]];
}

- (instancetype) initWithNSArray:(NSArray *)array
{
    NSParameterAssert(array);
    NSMutableArray *arr = array ? [array mutableCopy] : [NSMutableArray array];
    if (self = [super init]) {
        GPS_LOCK_INIT(_arrayLock);
        _mutableArray = arr;
    }
    
    return self;
}

- (NSUInteger) count
{
    GPS_SCOPE_LOCK(_arrayLock);
    return _mutableArray.count;
}

- (nonnull NSArray *) toArray
{
    GPS_SCOPE_LOCK(_arrayLock);
    return [_mutableArray copy];
}

#pragma mark -  get methods

- (nullable id) objectAtIndex:(NSUInteger)index
{
    GPS_SCOPE_LOCK(_arrayLock);
    return [_mutableArray objectAtIndex:index];
}

- (id) objectAtIndexedSubscript:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

#pragma mark - add methods

- (void) insertObject:(id)anObject atIndex:(NSUInteger)index
{
    GPS_SCOPE_LOCK(_arrayLock);
    return [_mutableArray insertObject:anObject atIndex:index];
}

- (void) addObject:(id)anObject
{
    return [self insertObject:anObject atIndex:self.count];
}

#pragma mark - remove methods

- (void) removeLastObject
{
    if (self.count >= 1) {
        [self removeObjectAtIndex:(self.count - 1)];
    }
}

- (void) removeFirstObject
{
    if (self.count > 0) {
        [self removeObjectAtIndex:0];
    }
}

- (void) removeObjectAtIndex:(NSUInteger)index
{
    GPS_SCOPE_LOCK(_arrayLock);
    [_mutableArray removeObjectAtIndex:index];
}

- (void) removeObject:(id)anObject
{
    GPS_SCOPE_LOCK(_arrayLock);
    NSUInteger index = [GP_NEW_SEQ(_mutableArray) firstIndexWhere:gps_isEqual(anObject)];
    if (index != NSNotFound) {
        [_mutableArray removeObjectAtIndex:index];
    }
}

- (void) removeAllObjects
{
    GPS_SCOPE_LOCK(_arrayLock);
    [_mutableArray removeAllObjects];
}

#pragma mark - replace methods

- (void) replaceObjectAtIndex:(NSUInteger)index
                   withObject:(id)anObject
{
    if (index < self.count) {
        [self setObject:anObject atIndexedSubscript:index];
    }
}

- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    GPS_SCOPE_LOCK(_arrayLock);
    [_mutableArray setObject:obj atIndexedSubscript:idx];
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger) countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state
                                   objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer
                                     count:(NSUInteger)len
{
    //
    // 每一次遍历都是复制了一份，
    // 防止多线程下的数据冲突问题
    //
    __autoreleasing NSArray *array = ({
        GPS_SCOPE_LOCK(_arrayLock);
        [_mutableArray copy];
    });
    
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id) copyWithZone:(NSZone *)zone
{
    GPSArray *newArray = [[self class] allocWithZone:zone];
    GPS_LOCK_INIT(newArray->_arrayLock);
    GPS_SCOPE_LOCK(_arrayLock);
    newArray->_mutableArray = [_mutableArray mutableCopy];
    return newArray;
}

- (BOOL) isEqual:(id)object
{
    GPS_SCOPE_LOCK(_arrayLock);
    
    if ([object isKindOfClass:[NSArray class]]) {
        return [_mutableArray isEqualToArray:object];
    } else if ([object isKindOfClass:[self class]]) {
        GPSArray *rightValue = (GPSArray *)object;
        GPS_SCOPE_LOCK(rightValue->_arrayLock);
        return [_mutableArray isEqualToArray:rightValue->_mutableArray];
    }
    
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@" %@: %@", NSStringFromClass([self class]), GP_NEW_SEQ(self)];
}

#pragma mark - GPSTransfer Protocol

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    NSMutableArray *array = [NSMutableArray array];
    [sequence forEach:^(id  _Nonnull item) {
        [array addObject:item];
    }];
    
    return [[GPSArray alloc] initWithNSArray:array];
}

@end
