//
//  GPSeq.m
//  GPSequence
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSequence.h"
#import "GPBlockDefine.h"
#import "GPSTransfer.h"
#import "GPSEnumerator.h"

@interface GPSequence()
@property (nonatomic, strong) id<NSFastEnumeration> originSequence;
@end

@implementation GPSequence

- (instancetype)initWithOriginSequence:(id<NSFastEnumeration>)originSequence
{
    NSParameterAssert(originSequence);
    if (self = [super init]) {
        _originSequence = originSequence;
    }
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state
                                  objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer
                                    count:(NSUInteger)len
{
    return [self.originSequence countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)as:(Class)clazz
{
    NSParameterAssert([clazz conformsToProtocol:@protocol(GPSTransfer)]);
    return [clazz transferFromSequence:self];
}

- (NSEnumerator *) objectEnumerator
{
    return [[GPSEnumerator alloc] initWithFastEnumerator:self.originSequence];
}

- (void) forEachWithIndexAndStop:(void (^ NS_NOESCAPE )(id _Nonnull, NSUInteger, BOOL * _Nonnull))eachBlock
{
    NSParameterAssert(eachBlock);
    if (!eachBlock) {
        return;
    }
    
    NSUInteger index = 0;
    BOOL stop = NO;
    for (id item in self.originSequence) {
        eachBlock(item, index++, &stop);
        if (stop) {
            break;
        }
    }
}

- (BOOL) isEqual:(id)object
{
    NSParameterAssert([[object class] conformsToProtocol:@protocol(NSFastEnumeration)]);
    NSEnumerator *selfEnumerator = [self objectEnumerator];
    NSEnumerator *otherEnumerator = [[GPSEnumerator alloc] initWithFastEnumerator:object];
    
    id leftValue = nil;
    id rightValue = nil;
    
    do {
        leftValue = [selfEnumerator nextObject];
        rightValue = [otherEnumerator nextObject];
        
        if (leftValue == rightValue || [leftValue isEqual:rightValue]) {
            continue;
        }
        return NO;
    } while (leftValue != nil);
    return YES;
}

- (NSString *)description
{
    return [[self as:NSArray.class] description];
}

@end
