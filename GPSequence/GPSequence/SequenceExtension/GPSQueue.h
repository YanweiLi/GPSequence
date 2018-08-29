//
//  GPSQueue.h
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSTransfer.h"

@interface GPSQueue <__covariant T>: NSObject <NSFastEnumeration, NSCopying, GPSTransfer>

@property (atomic, readonly, assign, getter=isEmpty) BOOL empty;
@property (atomic, readonly, assign) NSUInteger count;
@property (atomic, readonly, strong) T front;

- (void)enqueue:(T)item;
- (T)dequeue;
- (BOOL)contains:(T)item;

@end
