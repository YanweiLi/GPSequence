//
//  GPSWeakReference.h
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPSWeakReference <T> : NSObject

/**
 弱引用对象
 */
@property (nonatomic, readonly, weak) T reference;

+ (instancetype)reference:(nonnull T)reference;

- (instancetype)initWithReference:(nonnull T)reference
                     deallocBlock:(void (^_Nullable)(GPSWeakReference * _Nonnull reference)) deallocBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
