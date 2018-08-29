//
//  GPSQueue.m
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPSQueue.h"
#import "GPSequence+Operations.h"
#import "GPSUsefulBlocks.h"
#import "GPMarcoDefine.h"

@interface GPSLinkedList<T> : NSObject <NSCopying>

@property (nonatomic, strong) T value;
@property (nonatomic, strong) GPSLinkedList *next;
@property (nonatomic, strong) GPSLinkedList *before;

- (instancetype)initWithValue:(T)value next:(GPSLinkedList *)next NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithValue:(T)value;
- (instancetype)init;

@end

@implementation GPSLinkedList

- (instancetype)initWithValue:(id)value
                         next:(GPSLinkedList *)next
{
    if (self = [super init]) {
        _value = value;
        _next = next;
        _before = nil;
    }
    return self;
}

- (instancetype)initWithValue:(id)value
{
    return [self initWithValue:value next:nil];
}

- (instancetype)init
{
    return [self initWithValue:nil next:nil];
}

- (nonnull id) copyWithZone:(nullable NSZone *)zone
{
    GPSLinkedList *copiedLinkedList = [GPSLinkedList allocWithZone:zone];
    copiedLinkedList->_value = self.value;
    copiedLinkedList->_next = [self.next copyWithZone:zone];
    return copiedLinkedList;
}

- (BOOL) isEqual:(GPSLinkedList *)another
{
    if ([another isKindOfClass:[self class]]) {
        if (self.value == another.value || [self.value isEqual:another.value]) {
            if (self.next == nil && another.next == nil) {
                return YES;
            }
            
            return [self.next isEqual:another.next];
        }
    }
    
    return NO;
}

@end

////////////////////////////////////////////////////////////////////////

@implementation GPSQueue
{
    GPS_LOCK_DEF(_linkedListLock);
    GPSLinkedList *_front;
    GPSLinkedList *_tail;
}

- (instancetype) init
{
    if (self = [super init]) {
        GPS_LOCK_INIT(_linkedListLock);
    }
    return self;
}

- (BOOL) isEmpty
{
    GPS_SCOPE_LOCK(_linkedListLock);
    return _front == nil;
}

- (NSUInteger) count
{
    GPS_SCOPE_LOCK(_linkedListLock);
    NSUInteger count = 0;
    GPSLinkedList *list = _front;
    while (list) {
        ++count;
        list = list.next;
    }
    return count;
}

- (void) enqueue:(id)item
{
    GPS_SCOPE_LOCK(_linkedListLock);
    GPSLinkedList *list = [[GPSLinkedList alloc] initWithValue:item];
    if (_tail) {
        _tail.next = list;
        list.before = _tail;
    }
    
    _tail = list;
    if (_front == nil) {
        _front = list;
    }
}

- (id) dequeue
{
    GPS_SCOPE_LOCK(_linkedListLock);
    id value = _front.value;
    _front = _front.next;
    if (_front == nil) {
        _tail = nil;
    }
    
    return value;
}

- (id) front
{
    GPS_SCOPE_LOCK(_linkedListLock);
    return _front.value;
}

- (instancetype) copyWithZone:(NSZone *)zone
{
    GPSQueue *newQuque = [GPSQueue allocWithZone:zone];
    GPS_LOCK_INIT(newQuque->_linkedListLock);
    GPS_SCOPE_LOCK(_linkedListLock);
    newQuque->_front = [_front copyWithZone:zone];
    
    GPSLinkedList *list = newQuque->_front;
    GPSLinkedList *tail = nil;
    while (list) {
        tail = list;
        list = list.next;
    }
    
    newQuque->_tail = tail;
    return newQuque;
}

- (BOOL) isEqual:(GPSQueue *)object
{
    GPS_SCOPE_LOCK(_linkedListLock);
    GPS_SCOPE_LOCK(object->_linkedListLock);
    return [_front isEqual:object->_front];
}

- (BOOL) contains:(id)item
{
    GPS_SCOPE_LOCK(_linkedListLock);
    GPSLinkedList *list = _front;
    
    while (list) {
        if (list.value == item) {
            return YES;
        }
        
        list = list.next;
    }
    
    return NO;
}

+ (instancetype) transferFromSequence:(GPSequence *)sequence
{
    GPSQueue *queue = [[GPSQueue alloc] init];
    [sequence forEach:^(id  _Nonnull item) {
        [queue enqueue:item];
    }];
    
    return queue;
}

#pragma mark - NSFastEnumeration Protocol

- (NSUInteger) countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state
                                   objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer
                                     count:(NSUInteger)len
{
    NSUInteger count = self.count;
    
    // 这里是个问题
//    if (state->state == count) {
//        return 0;
//    }
//
//    Ivar ivar = class_getInstanceVariable(self.class, "_first");
//
//    state->itemsPtr = (id  _Nullable __unsafe_unretained * _Nonnull)((__bridge void *)self + ivar_getOffset(ivar));
//    state->mutationsPtr = (typeof(state->mutationsPtr))&self->_hashValue;
//
//    state->state = count;
    return count;
}
@end
