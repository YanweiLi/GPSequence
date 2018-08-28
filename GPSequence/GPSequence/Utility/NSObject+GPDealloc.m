//
//  NSObject+GPDealloc.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "NSObject+GPDealloc.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////

@interface GPSDeallocBell : NSObject
@property (nonatomic, readonly, copy) GPSVoidBlock callback;
- (instancetype)initWithBlock:(nonnull GPSVoidBlock)block;
@end

@implementation GPSDeallocBell

- (instancetype)initWithBlock:(GPSVoidBlock)block
{
    if (self = [super init]) {
        _callback = [block copy];
    }

    return self;
}

- (void)dealloc
{
    if (self.callback) {
        self.callback();
    }
}

@end

////////////////////////////////////////////////////////////////

@implementation NSObject (GPDealloc)

- (void)addDeallocCallback:(GPSVoidBlock)block
{
    GPSDeallocBell *bell = [[GPSDeallocBell alloc] initWithBlock:block];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(bell), bell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
