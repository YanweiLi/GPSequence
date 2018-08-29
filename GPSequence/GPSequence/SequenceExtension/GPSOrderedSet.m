//
//  GPSOrderedSet.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSOrderedSet.h"
#import "GPSequence+Operations.h"
#import "GPSUsefulBlocks.h"
#import "GPMarcoDefine.h"

@implementation GPSOrderedSet
{
    NSMutableOrderedSet *_mutbleOrderSet;
    GPS_LOCK_DEF(_orderedSetLock);
}

#pragma mark - init

- (instancetype) init
{
    return [self initWithNSOrderedSet:[NSOrderedSet orderedSet]];
}

- (instancetype) initWithNSArray:(NSArray *)array
{
    NSParameterAssert(array);
    NSOrderedSet *set = array ? [NSOrderedSet orderedSetWithArray:array] : [NSOrderedSet orderedSet];
    return [self initWithNSOrderedSet:set];
}

- (instancetype) initWithNSOrderedSet:(NSOrderedSet *)set
{
    NSParameterAssert(set);
    set = set ?: [NSOrderedSet orderedSet];
    if (self = [super init]) {
        _mutbleOrderSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:set];
        GPS_LOCK_INIT(_orderedSetLock);
    }
    return self;
}

- (NSUInteger) count
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    return _mutbleOrderSet.count;
}

#pragma mark -  get methods

- (id) objectAtIndex:(NSUInteger)index
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    return [_mutbleOrderSet objectAtIndex:index];
}

- (id) objectAtIndexedSubscript:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

#pragma mark - add methods

- (void) addObject:(id)anObject
{
    [self insertObject:anObject atIndex:self.count];
}

- (void) insertObject:(id)anObject atIndex:(NSUInteger)index
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    [_mutbleOrderSet insertObject:anObject atIndex:index];
}

#pragma mark - remove methods

- (void) removeLastObject
{
    if (self.count >= 1) {
        [self removeObjectAtIndex:(_mutbleOrderSet.count - 1)];
    }
}

- (void) removeFirstObject
{
    if (self.count > 0){
        [self removeObjectAtIndex:0];
    }
}

- (void) removeObjectAtIndex:(NSUInteger)index
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    [_mutbleOrderSet removeObjectAtIndex:index];
}

- (void) removeObject:(id)anObject
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    NSUInteger index = [GP_NEW_SEQ(_mutbleOrderSet) firstIndexWhere:gps_isEqual(anObject)];
    if (index != NSNotFound) {
        [_mutbleOrderSet removeObjectAtIndex:index];
    }
}

- (void) removeAllObjects
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    [_mutbleOrderSet removeAllObjects];
}

#pragma mark - replace methods

- (void) replaceObjectAtIndex:(NSUInteger)index
                   withObject:(id)anObject
{
    if (index < self.count) {
        [self setObject:anObject atIndexedSubscript:index];
    }
}

- (void) setObject:(id)obj
atIndexedSubscript:(NSUInteger)idx
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    [_mutbleOrderSet setObject:obj atIndexedSubscript:idx];
}

- (NSArray *) allObjects
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    return _mutbleOrderSet.array;
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger) countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state
                                   objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer
                                     count:(NSUInteger)len
{
    __autoreleasing NSOrderedSet *orderedSet = ({
        GPS_SCOPE_LOCK(_orderedSetLock);
        [_mutbleOrderSet copy];
    });
    return [orderedSet countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id) copyWithZone:(NSZone *)zone
{
    GPSOrderedSet *newInstance = [[self class] allocWithZone:zone];
    GPS_LOCK_INIT(newInstance->_orderedSetLock);
    {
        GPS_SCOPE_LOCK(_orderedSetLock);
        newInstance->_mutbleOrderSet = [_mutbleOrderSet mutableCopy];
    }
    
    return newInstance;
}

- (BOOL) isEqual:(id)object
{
    GPS_SCOPE_LOCK(_orderedSetLock);
    if ([object isKindOfClass:[NSOrderedSet class]]) {
        return [_mutbleOrderSet isEqualToOrderedSet:object];
    } else if ([object isKindOfClass:[self class]]) {
        GPSOrderedSet *anOtherSet = object;
        GPS_SCOPE_LOCK(anOtherSet->_orderedSetLock);
        return [_mutbleOrderSet isEqualToOrderedSet:anOtherSet->_mutbleOrderSet];
    }
    
    return NO;
}

#pragma mark - EZSTransfer Protocol

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    
    return [[GPSOrderedSet alloc] initWithNSOrderedSet:set];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@" %@: {%@}", NSStringFromClass([self class]), GP_NEW_SEQ(self)];
}
@end
