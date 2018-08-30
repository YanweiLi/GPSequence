//
//  GPSEnumerator.h
//  GPSequence
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPSEnumerator : NSEnumerator

- (instancetype)initWithFastEnumerator:(id<NSFastEnumeration>)fastEnumerator NS_DESIGNATED_INITIALIZER;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new  NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
