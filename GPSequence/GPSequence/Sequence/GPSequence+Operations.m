//
//  GPSequence+Operations.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSequence+Operations.h"
#import "GPBlockDefine.h"
#import "GPMarcoDefine.h"
#import "GPSUsefulBlocks.h"
#import "GPSEnumerator.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
// 错误信息

NSString * const GPSequenceExceptionName = @"GPSequenceExceptionName";
NSString * const GPSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation =
@"GPSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation";
NSString * const GPSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration =
@"GPSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration";

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation GPSequence (Operations)


- (void)forEachWithIndex:(void (^)(id _Nonnull, NSUInteger))eachBlock
{
    NSParameterAssert(eachBlock);
    if (!eachBlock) {
        return;
    }
    
    void (^block)(id _Nonnull, NSUInteger, BOOL * _Nonnull) = ^(id item, NSUInteger index, BOOL * _) {
        eachBlock(item, index);
    };
    
    [self forEachWithIndexAndStop:block];
}

- (void)forEach:(void (^)(id _Nonnull))eachBlock
{
    NSParameterAssert(eachBlock);
    if (!eachBlock) {
        return;
    }
    
    void (^block)(id _Nonnull, NSUInteger, BOOL * _Nonnull) = ^(id item, NSUInteger index, BOOL * _) {
        eachBlock(item);
    };
    [self forEachWithIndexAndStop:block];
}

- (GPSequence *)flattenMap:(GPSFlattenMapBlock)flattenBlock
{
    NSParameterAssert(flattenBlock);
    NSMutableArray *array = [NSMutableArray new];
    for (id item in self) {
        if (flattenBlock) {
            id<NSFastEnumeration> sequence = flattenBlock(item);
            if (!GPS_idConformsTo(sequence, NSFastEnumeration)) {
                GPS_THROW(GPSequenceExceptionName, GPSequenceExceptionReason_ResultOfFlattenMapBlockMustConformsNSFastEnumeation, nil);
            }
            
            for (id insideItem in sequence) {
                [array addObject:insideItem];
            }
        }
    };
    return GP_NEW_SEQ(array);
}

- (GPSequence *)flatten {
    NSMutableArray *array = [NSMutableArray array];
    [self forEach:^(id  _Nonnull item) {
        if ([item conformsToProtocol:@protocol(NSFastEnumeration)]) {
            for (id innerItem in item) {
                [array addObject:innerItem];
            }
        } else {
            [array addObject:item];
        }
    }];
    return GP_NEW_SEQ(array);
}

- (GPSequence *)concat:(id<NSFastEnumeration>)anotherSequence {
    NSParameterAssert(anotherSequence);
    if (!anotherSequence) { return self; }
    return [GP_NEW_SEQ(@[self, anotherSequence]) flatten];
}

+ (GPSequence *)concatSequences:(id<NSFastEnumeration>)sequences {
    NSParameterAssert(sequences);
    if (!sequences) { return nil; }
    return [GP_NEW_SEQ(sequences) flatten];
}

- (GPSequence *)filter:(GPSFliterBlock)filterBlock {
    NSParameterAssert(filterBlock);
    NSMutableArray *array = [NSMutableArray new];
    for (id item in self) {
        if (filterBlock && filterBlock(item)) {
            [array addObject:item];
        }
    };
    return GP_NEW_SEQ(array);
}

- (GPSequence *)map:(GPSMapBlock)mapBlock {
    NSParameterAssert(mapBlock);
    if (!mapBlock) { return nil; }
    id (^block)(id, NSUInteger) = ^(id item, NSUInteger _) {
        return mapBlock(item);
    };
    return [self mapWithIndex:block];
}

- (GPSequence *)mapWithIndex:(id  _Nonnull (^)(id _Nonnull, NSUInteger))mapBlock {
    NSParameterAssert(mapBlock);
    if (!mapBlock) { return nil;}
    NSMutableArray *array = [NSMutableArray new];
    NSUInteger index = 0;
    for (id item in self) {
        if (mapBlock) {
            [array addObject:mapBlock(item, index++)];
        }
    };
    return GP_NEW_SEQ(array);
}

- (GPSequence *)take:(NSUInteger)count {
    NSParameterAssert(count > 0);
    NSMutableArray *array = [NSMutableArray new];
    [self forEachWithIndexAndStop:^(id  _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
        if (index < count) {
            [array addObject:item];
        } else {
            *stop = YES;
        }
    }];
    return GP_NEW_SEQ(array);
}

- (GPSequence *)skip:(NSUInteger)count {
    NSParameterAssert(count >= 0);
    NSMutableArray *array = [NSMutableArray new];
    [self forEachWithIndexAndStop:^(id  _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
        if (index >= count) {
            [array addObject:item];
        }
    }];
    return GP_NEW_SEQ(array);
}

- (nullable id)firstObject {
    for (id item in self) {
        return item;
    }
    return nil;
}

- (id)firstObjectWhere:(GPSFliterBlock)checkBlock {
    NSParameterAssert(checkBlock);
    if (!checkBlock) { return nil; }
    for (id item in self) {
        if (checkBlock(item)) {
            return item;
        }
    }
    return nil;
}

- (NSUInteger)firstIndexWhere:(GPSFliterBlock)checkBlock {
    NSParameterAssert(checkBlock);
    if (!checkBlock) { return NSNotFound; }
    NSUInteger index = 0;
    for (id item in self) {
        if (checkBlock(item)) {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

- (BOOL)any:(BOOL (^)(id _Nonnull))checkBlock {
    NSParameterAssert(checkBlock);
    if (!checkBlock) { return NO; }
    BOOL result = NO;
    for (id item in self) {
        result = checkBlock(item);
        if (result) {
            return result;
        }
    }
    return result;
}

- (GPSequence *)select:(BOOL (^)(id _Nonnull))selectBlock {
    NSParameterAssert(selectBlock);
    return [self filter:selectBlock];
}

- (GPSequence *)reject:(BOOL (^)(id _Nonnull))rejectBlock {
    NSParameterAssert(rejectBlock);
    if (!rejectBlock) { return nil;}
    return [self select:gps_not(rejectBlock)];
}

- (id)reduceStart:(id)startValue withBlock:(id  _Nullable (^)(id _Nullable, id _Nullable))reduceBlock {
    NSParameterAssert(reduceBlock);
    if (!reduceBlock) { return nil; }
    id result = startValue;
    for (id value in self) {
        result = reduceBlock(result, value);
    }
    return result;
}

- (id)reduce:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))reduceBlock {
    NSParameterAssert(reduceBlock);
    if (!reduceBlock) { return nil; }
    return [[self skip:1] reduceStart:self.firstObject withBlock:reduceBlock];
}

- (NSDictionary<id<NSCopying>, id> *)groupBy:(id<NSCopying>  _Nonnull (^)(id _Nonnull))groupBlock {
    NSParameterAssert(groupBlock);
    if (!groupBlock) { return nil; }
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    for (id value in self) {
        id key = groupBlock(value);
        NSAssert(key, @"key is nil");
        if (!mutableDic[key]) {
            mutableDic[key] = [NSMutableArray new];
        }
        [mutableDic[key] addObject:value];
    }
    
    for (id key in mutableDic.allKeys) {
        NSMutableArray *items = mutableDic[key];
        mutableDic[key] = GP_NEW_SEQ(items);
    }
    return [mutableDic copy];
}

+ (GPSequence<GPSequence *> *)zipSequences:(id<NSFastEnumeration>)zippedEnumeration {
    NSParameterAssert(zippedEnumeration);
    if (!zippedEnumeration) { return nil; }
    NSMutableArray<GPSequence *> *result = [NSMutableArray new];
    GPSequence<GPSEnumerator *> *sequences = [GP_NEW_SEQ_WITH_TYPE(id<NSFastEnumeration>, zippedEnumeration) map:^id _Nonnull(id<NSFastEnumeration>  _Nonnull item) {
        if (!GPS_idConformsTo(item, NSFastEnumeration)) {
            GPS_THROW(GPSequenceExceptionName, GPSequenceExceptionReason_ZipMethodMustUseOnNSFastEnumerationOfNSFastEnumeration, nil);
        }
        return GP_NEW_SEQ_WITH_TYPE(GPSequence *, item).objectEnumerator;
    }];
    
    
    NSObject *endMarker = NSObject.new;
    for (;;) {
        GPSequence *values = [sequences map:^id _Nonnull(GPSEnumerator * _Nonnull item) {
            __block id next = [item nextObject];
            return next ?: endMarker;
        }];
        if ([values any:gps_isEqual(endMarker)]) {
            break;
        }
        [result addObject:values];
    }
    return GP_NEW_SEQ_WITH_TYPE(GPSequence *, result);
}

- (GPSequence<GPSequence *> *)zip:(id<NSFastEnumeration>)anotherSequence {
    NSParameterAssert(anotherSequence);
    if (!anotherSequence) { return nil; }
    return [GPSequence zipSequences:@[self, anotherSequence]];
}

@end
