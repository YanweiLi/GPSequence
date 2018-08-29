//
//  NSArray+Transfer.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "NSArray+GPSTransfer.h"
#import "GPSequence+Operations.h"

@implementation NSArray (GPSTransfer)

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    NSMutableArray *array = [NSMutableArray array];
    [sequence forEach:^(id  _Nonnull item) {
        [array addObject:item];
    }];
    return [array copy];
}

@end
