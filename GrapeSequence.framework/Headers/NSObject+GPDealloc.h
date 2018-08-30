//
//  NSObject+GPDealloc.h
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPBlockDefine.h"

@interface NSObject (GPDealloc)
- (void)addDeallocCallback:(GPSVoidBlock)block;
@end
