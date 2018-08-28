//
//  GPSWeakReference.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSWeakReference.h"
#import "GPBlockDefine.h"
#import "NSObject+GPDealloc.h"

@interface GPSWeakReference()
@property (nonatomic , assign) NSUInteger referenceHash;
@property (nonatomic, readonly, copy) GPSApplyBlock block;
@end

@implementation GPSWeakReference

- (instancetype)initWithReference:(NSObject *)reference
                     deallocBlock:(void (^_Nullable)(GPSWeakReference * _Nonnull reference))deallocBlock
{
    if (self = [super init]) {
        _reference = reference;
        _referenceHash = reference.hash;
        _block = [deallocBlock copy];
        
        if (_block) {
            __weak GPSApplyBlock weakDeallocBlock = _block;
            [reference addDeallocCallback:^{
                GPSApplyBlock strongDeallocBlock = weakDeallocBlock;
                if (strongDeallocBlock) {
                    strongDeallocBlock(self);
                }
            }];
        }
    }
    
    return self;
}

+ (instancetype)reference:(nonnull id)reference
{
    return [[self alloc] initWithReference:reference deallocBlock:nil];
}

- (NSUInteger)hash
{
    return _referenceHash;
}

- (BOOL)isEqual:(GPSWeakReference *)object
{
    if ([object isKindOfClass:[self class]]) {
        return [self.reference isEqual:object.reference];
    } else {
        return [self.reference isEqual:object];
    }
}

- (NSString *)description
{
    return _reference ? [_reference description] : [super description];
}
@end
