//
//  NSObject+GPSequence.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "NSObject+GPSequence.h"
#import "GPSequence.h"
#import "GPMarcoDefine.h"

@implementation NSObject (GPSequence)

- (GPSequence *) gps_asSequence
{
    NSAssert(GPS_idConformsTo(self, NSFastEnumeration), @"%@'s class not conform protocol NSFastEnumeration", self);
    
    return GP_NEW_SEQ((id<NSFastEnumeration>)self);
}

@end
