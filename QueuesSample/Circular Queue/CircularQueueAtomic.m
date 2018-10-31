//
//  CircularQueueAtomic.m
//  QueuesSample
//
//  Created by NakCheon Jung on 22/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import "CircularQueueAtomic.h"
#import <libkern/OSAtomic.h>
#import <stdatomic.h>

// 참고 thread safe operaions in iOS: http://www.lukeparham.com/blog/2018/6/3/comparing-synchronization-strategies
// 참고 환영큐: https://www.geeksforgeeks.org/circular-queue-set-1-introduction-array-implementation/

@interface CircularQueueAtomic () {
    NSMutableArray *_queue;
    NSInteger _front;
    NSInteger _size;
    volatile atomic_uint _lock;
}
@property (assign, nonatomic, readonly) BOOL isEmpyt;

@end

@implementation CircularQueueAtomic

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_queue = [[NSMutableArray alloc] init];
        self->_front = 0;
        self->_size = 0;
        self->_lock = 0;
    }
    return self;
}

- (NSUInteger)toOffset:(NSInteger)index {
    NSUInteger offset = (self->_front + index) % self->_queue.count;
    return offset;
}

- (BOOL)isEmpyt
{
    if (_size == 0) {
        return YES;
    }
    return NO;
}

- (id)itemAt:(NSInteger)index
{
    NSUInteger at = [self toOffset:index];
    return _queue[at];
}

- (void)setItem:(id)item at:(NSInteger)index
{
    NSUInteger at = [self toOffset:index];
    _queue[at] = item;
}

- (void)_acquireLock {
    while (self->_lock != 0) {
        //[NSThread sleepForTimeInterval:0.000001];
    }
    volatile atomic_uint value = 1;
    
    BOOL swapped = NO;
    while (!swapped) {
        uint old = 0;
        swapped = atomic_compare_exchange_strong(&self->_lock, &old, (uint)value);
    }
    // atomic_compare_exchange_strong(object/*바꿀곳*/, expected/*old 값*/, desired/*미래값*/)
    //NSLog(@"lock acquired");
}

- (void)_releaseLock {

    volatile atomic_uint value = 0;
    
    BOOL swapped = NO;
    while (!swapped) {
        uint old = 1;
        swapped = atomic_compare_exchange_strong(&self->_lock, &old, (uint)value);
    }
    // atomic_compare_exchange_strong(object/*바꿀곳*/, expected/*old 값*/, desired/*미래값*/)
    //NSLog(@"lock released");
}

- (void)ensureCapacity:(NSInteger)count
{
    if (_front == 0) {
        return;
    }
    if (_queue.count >= count) {
        return;
    }
    NSMutableArray *arrayCopy = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _queue.count; ++i) {
        [arrayCopy addObject:[self itemAt:i]];
    }
    _queue = arrayCopy;
}

- (BOOL)enQneue:(id)item
{
    //id addItem = [item copy];
    [self _acquireLock];
    
    [self ensureCapacity:_queue.count + 1];
    
    if (_front == 0) {
        //[self->_queue addObject:addItem];
        [self->_queue addObject:item];
    }
    else {
        NSInteger index = [self toOffset:_size++];
        //self->_queue[index] = addItem;
        self->_queue[index] = item;
    }
    
    [self _releaseLock];
    return YES;
}

- (id)deQueue
{
    [self _acquireLock];
    
    id item = nil;
    
    if (self.isEmpyt) {
        [self _releaseLock];
        return nil;
    }
    NSInteger index = [self toOffset:_front];
    item = self->_queue[index];
    _front = (_front + 1) % _queue.count;
    --_size;
    
    [self _releaseLock];
    
    return item;
}

- (void)printQueue
{
    [self _acquireLock];
    
    NSString *string = @"";
    
    for (NSInteger i = 0; i < _size; ++i) {
        id item = [self itemAt:i];
        string = [string stringByAppendingFormat:@"%@", item];
        string = [string stringByAppendingString:@" > "];
    }
    string = [string substringToIndex:string.length - 3];
    NSLog(@"%@", string);
    
    [self _releaseLock];
}

@end
