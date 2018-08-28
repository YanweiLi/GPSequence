//
//  GPMarcoDefine.h
//  GPSequence
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef GP_MARCO_DEFINE_H_
#define GP_MARCO_DEFINE_H_

#define GPS_CONCAT(A, B)             GPS_CONCAT_(A, B)
#define GPS_CONCAT_(A, B)            A ## B

#define GPS_LOCK_TYPE                dispatch_semaphore_t
#define GPS_LOCK_DEF(LOCK)           dispatch_semaphore_t LOCK
#define GPS_LOCK_INIT(LOCK)          LOCK = dispatch_semaphore_create(1)
#define GPS_LOCK(LOCK)               dispatch_semaphore_wait(LOCK, DISPATCH_TIME_FOREVER)
#define GPS_UNLOCK(LOCK)             dispatch_semaphore_signal(LOCK)

static inline void GPS_unlock(GPS_LOCK_TYPE *lock) {
    GPS_UNLOCK(*lock);
}

// 锁自动释放操作
#define GPS_SCOPELOCK(LOCK)          GPS_LOCK(LOCK);GPS_LOCK_TYPE GPS_CONCAT(auto_lock_, __LINE__) __attribute__((cleanup(GPS_unlock), unused)) = LOCK

static inline BOOL GPS_idConformsToProtocol(id object, Protocol *protocol) {
    return [[object class] conformsToProtocol:protocol];
}

#define GPS_idConformsTo(obj, pro) GPS_idConformsToProtocol(obj, @protocol(pro))

#define GPS_THROW(NAME, REASON, INFO)                            \
NSException *exception = [[NSException alloc] initWithName:NAME reason:REASON userInfo:INFO]; @throw exception;

#endif /* GP_MARCO_DEFINE_H_ */

