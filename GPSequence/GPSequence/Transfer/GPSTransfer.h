//
//  GPSTransfer.h
//  GPSTransfer
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GPSequence;

@protocol GPSTransfer <NSObject>

/**
 GPSequence 转换成其他类型

 @param sequence GPSequence
 @return 其他类型
 */
+ (instancetype)transferFromSequence:(GPSequence *)sequence;
@end
