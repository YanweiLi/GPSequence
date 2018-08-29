//
//  NSOrderedSet+GPSTransfer.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "NSOrderedSet+GPSTransfer.h"
#import "GPSequence+Operations.h"

@implementation NSOrderedSet (GPSTransfer)

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    return [set copy];
}

@end
