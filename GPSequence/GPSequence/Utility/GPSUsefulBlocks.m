//
//  GPSUsefulBlocks.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSUsefulBlocks.h"

GPSMapBlock gps_id(void)
{
    return ^id(id _) {
        return _;
    };
}

GPSFliterBlock gps_isKindOf_(Class klass)
{
    return ^BOOL(id instance) {
        return [instance isKindOfClass:klass];
    };
}

GPSFliterBlock gps_isEqual(id value)
{
    return ^BOOL(id instance) {
        return instance == value || [instance isEqual:value];
    };
}

GPSFliterBlock gps_not(GPSFliterBlock block)
{
    return ^BOOL(id instance) {
        return !block(instance);
    };
}

GPSFliterBlock gps_isExists()
{
    return ^BOOL(id _) {
        return !!_;
    };
}

GPSMapBlock gps_valueForKeypath(NSString *keyPath)
{
    return ^id(id object) {
        return [object valueForKeyPath:keyPath];
    };
}

GPSMapBlock gps_valueForKey(NSString *key)
{
    return ^id(id object) {
        return [object valueForKey:key];
    };
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

GPSApplyBlock gps_performSelector(SEL selector)
{
    return ^(id object) {
        [object performSelector:selector];
    };
}

GPSApplyBlock gps_performSelector1(SEL selector, id param1)
{
    return ^(id object) {
        [object performSelector:selector withObject:param1];
    };
}

GPSApplyBlock gps_performSelector2(SEL selector, id param1, id param2)
{
    return ^(id object) {
        [object performSelector:selector withObject:param1 withObject:param2];
    };
}

GPSMapBlock gps_mapWithSelector(SEL selector)
{
    return ^id(id object) {
        return [object performSelector:selector];
    };
}

GPSMapBlock gps_mapWithSelector1(SEL selector, id param1)
{
    return ^id(id object) {
        return [object performSelector:selector withObject:param1];
    };
}

GPSMapBlock gps_mapWithSelector2(SEL selector, id param1, id param2)
{
    return ^id(id object) {
        return [object performSelector:selector withObject:param1 withObject:param2];
    };
}

#pragma clang diagnostic pop

BOOL gps_instanceEqual(id left, id right)
{
    if (left == right) { return YES; }
    if ([left respondsToSelector:@selector(isEqual:)]) {
        return [left isEqual:right];
    }
    if ([right respondsToSelector:@selector(isEqual:)]) {
        return [right isEqual:left];
    }
    return NO;
}
