//
//  GPBlockDefine.h
//  GPSequence
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#ifndef GP_BLOCK_DEFINE_H_
#define GP_BLOCK_DEFINE_H_

typedef void (^GPSVoidBlock)(void);
typedef void (^GPSForEachBlock)(id value);
typedef GPSForEachBlock GPSApplyBlock;

typedef id (^GPSMapBlock)(id value);
typedef BOOL (^GPSFliterBlock)(id value);
typedef id<NSFastEnumeration> (^GPSFlattenMapBlock)(id value);

#endif /* GP_BLOCK_DEFINE_H_ */
