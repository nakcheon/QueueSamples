//
//  CircularQueueUsingLinkedList.m
//  QueuesSample
//
//  Created by NakCheon Jung on 22/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import "CircularQueueUsingLinkedList.h"
#import "Node.h"

// 참고 thread safe operaions in iOS: http://www.lukeparham.com/blog/2018/6/3/comparing-synchronization-strategies
// 참고 환영큐: https://www.geeksforgeeks.org/circular-queue-set-1-introduction-array-implementation/

@interface CircularQueueUsingLinkedList () {
    dispatch_queue_t _dispatch_queue;
    Node *_head;
    Node *_front;
    Node *_rear;
    NSInteger _size;
    NSInteger _nodeCount;
}
@property (assign, nonatomic, readonly) BOOL isEmpyt;

// private
- (Node *)_increaseRear:(Node *)pointer;
- (Node *)_increaseFront:(Node *)pointer;
@end

@implementation CircularQueueUsingLinkedList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dispatch_queue = dispatch_queue_create("com.CircularQueueUsingLinkedList.ThreadSafe", DISPATCH_QUEUE_SERIAL);
        _size = 5;
        dispatch_sync(self->_dispatch_queue, ^{
            self->_front = nil;
            self->_rear = nil;
            self->_head = [[Node alloc] init];
            self->_head.content = NSNull.null;
        });
        _nodeCount = 0;
    }
    return self;
}

- (BOOL)isFull
{
    if (!_rear && !_front) {
        return NO;
    }
    if (_rear.next == _front) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEmpyt
{
    if (!_front && !_rear) {
        return YES;
    }
    return NO;
}

- (BOOL)enQneue:(id)item
{
    if (self.isFull) {
        return NO;
    }
    dispatch_sync(self->_dispatch_queue, ^{
        if (!self->_front && !self->_rear) {
            self->_front = self->_head;
            self->_rear = self->_head;
        }
        else {
            self->_rear = [self _increaseRear:self->_rear];
        }
        self->_rear.content = item;
    });
    
    return YES;
}

- (id)deQueue
{
    if (self.isEmpyt) {
        return nil;
    }
    BOOL willEmpty = NO;
    if (_front == _rear) {
        willEmpty = YES;
    }
    
    __block id item = nil;
    dispatch_sync(self->_dispatch_queue, ^{
        item = self->_front.content;
        self->_front.content = NSNull.null;
        self->_front = [self _increaseFront:self->_front];
        
        if (willEmpty) {
            self->_front = nil;
            self->_rear = nil;
        }
    });
    return item;
}

- (void)printQueue
{
    dispatch_sync(self->_dispatch_queue, ^{
        NSString *string = @"";
        Node *current = self->_front;;
        do {
            string = [string stringByAppendingFormat:@"%@", current.content];
            string = [string stringByAppendingString:@" > "];
            current = current.next;
        } while (current && current != self->_front);
        string = [string substringToIndex:string.length - 3];
        NSLog(@"%@", string);
    });
}

#pragma mark - Private

- (Node *)_increaseRear:(Node *)pointer
{
    if (!pointer.next) {
        pointer.next = [[Node alloc] init];
        ++_nodeCount;
        if (_nodeCount == _size) {
            pointer.next = _head;
        }
    }
    
    Node *newPointer = pointer.next;
    
    return newPointer;
}

- (Node *)_increaseFront:(Node *)pointer
{
    Node *newPointer = pointer.next;
    return newPointer;
}

@end
