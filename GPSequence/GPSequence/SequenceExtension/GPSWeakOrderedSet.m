//
//  GPSWeakOrderedSet.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSWeakOrderedSet.h"
#import "GPSequence+Operations.h"
#import "GPSUsefulBlocks.h"
#import "GPMarcoDefine.h"
#import "GPSWeakReference.h"

@implementation GPSWeakOrderedSet

- (instancetype) initWithNSOrderedSet:(NSOrderedSet *)set
{
    NSParameterAssert(set);
    if (self = [super initWithNSOrderedSet:[NSOrderedSet orderedSet]]) {
        for (id item in set) {
            [self addObject:item];
        }
    }
    return self;
}

- (NSArray *) allObjects
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (GPSWeakReference *reference in [super allObjects]) {
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

#pragma mark -  get methods

- (id) objectAtIndex:(NSUInteger)index
{
    GPSWeakReference *obj = [super objectAtIndex:index];
    return obj.reference;
}

#pragma mark - add methods

- (void) insertObject:(id)anObject atIndex:(NSUInteger)index
{
    GPSWeakReference *obj = [self weakReference:anObject];
    [super insertObject:obj atIndex:index];
}

#pragma mark - replace methods

- (void) setObject:(id)anObject atIndexedSubscript:(NSUInteger)idx
{
    GPSWeakReference *obj = [self weakReference:anObject];
    [super setObject:obj atIndexedSubscript:idx];
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state
                                   objects:(id  _Nullable __unsafe_unretained [])buffer
                                     count:(NSUInteger)len
{
    __autoreleasing NSArray *array = self.allObjects;
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying Protocol

- (id) copyWithZone:(NSZone *)zone
{
    GPSWeakOrderedSet *newInstance = [[[self class] allocWithZone:zone] init];
    for (id item in self) {
        [newInstance addObject:item];
    }
    return newInstance;
}

#pragma mark - GPSTransfer Protocol

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    GPSWeakOrderedSet *set = [[GPSWeakOrderedSet alloc] init];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    
    return set;
}

@end
