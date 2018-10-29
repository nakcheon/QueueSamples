//
//  CircularQueue.m
//  QueuesSample
//
//  Created by NakCheon Jung on 22/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import "CircularQueue.h"

// 참고 thread safe operaions in iOS: http://www.lukeparham.com/blog/2018/6/3/comparing-synchronization-strategies
// 참고 환영큐: https://www.geeksforgeeks.org/circular-queue-set-1-introduction-array-implementation/

@interface CircularQueue () {
    NSMutableArray *_queue;
    NSInteger _front;
    NSInteger _size;
}
@property (assign, nonatomic, readonly) BOOL isEmpyt;

@end

@implementation CircularQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_queue = [[NSMutableArray alloc] init];
        self->_front = 0;
        self->_size = 0;
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

- (void)ensureCapacity:(NSInteger)count
{
    @synchronized (self) {
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
}

- (BOOL)enQneue:(id)item
{
    @synchronized (self) {
        [self ensureCapacity:_queue.count + 1];
        
        if (_front == 0) {
            [self->_queue addObject:item];
        }
        else {
            NSInteger index = [self toOffset:_size++];
            self->_queue[index] = item;
        }
    };
    return YES;
}

- (id)deQueue
{
    id item = nil;
    @synchronized (self) {
        if (self.isEmpyt) {
            return nil;
        }
        NSInteger index = [self toOffset:_front];
        item = self->_queue[index];
        _front = (_front + 1) % _queue.count;
        --_size;
    };
    
    return item;
}

- (void)printQueue
{
    @synchronized (self) {
        NSString *string = @"";
        
        for (NSInteger i = 0; i < _size; ++i) {
            id item = [self itemAt:i];
            string = [string stringByAppendingFormat:@"%@", item];
            string = [string stringByAppendingString:@" > "];
        }
        string = [string substringToIndex:string.length - 3];
        NSLog(@"%@", string);
    };
}

@end
