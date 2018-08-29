//
//  NSSet+GPSTransfer.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "NSSet+GPSTransfer.h"
#import "GPSequence+Operations.h"

@implementation NSSet (GPSTransfer)

+ (instancetype)transferFromSequence:(GPSequence *)sequence
{
    NSMutableSet *set = [NSMutableSet set];
    [sequence forEach:^(id  _Nonnull item) {
        [set addObject:item];
    }];
    return [set copy];
}

@end
