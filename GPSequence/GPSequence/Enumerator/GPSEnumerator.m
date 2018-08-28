//
//  GPSEnumerator.m
//  GPSequence
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSEnumerator.h"
static const long GPS_COMPARE_SIZE = 16;

@implementation GPSEnumerator
{
    NSUInteger _nextIndex;
    id<NSFastEnumeration> _fastEnumerator;
    NSFastEnumerationState _fastEnumeratorState;
    __unsafe_unretained id _buffer[GPS_COMPARE_SIZE];
    NSUInteger _lastCount;
    BOOL _fastEnumeratorFinished;
}

- (instancetype) initWithFastEnumerator:(id<NSFastEnumeration>)fastEnumerator
{
    NSParameterAssert(fastEnumerator);
    if (self = [super init]) {
        _nextIndex = 0;
        _fastEnumerator = fastEnumerator;
        _lastCount = 0;
    }
    return self;
}

- (id) nextObject
{
    if (_nextIndex >= _lastCount) {
        _lastCount = [_fastEnumerator countByEnumeratingWithState:&_fastEnumeratorState objects:_buffer count:GPS_COMPARE_SIZE];
        _nextIndex = 0;
    }
    
    if (_lastCount == 0)
    {
        return nil;
    }
    
    return _fastEnumeratorState.itemsPtr[_nextIndex++];
}

@end
