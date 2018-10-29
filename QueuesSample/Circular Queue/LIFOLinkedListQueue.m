//
//  LIFOLinkedListQueue.m
//  QueuesSample
//
//  Created by NakCheon Jung on 24/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import "LIFOLinkedListQueue.h"
#import "Node.h"

// 참고 thread safe operaions in iOS: http://www.lukeparham.com/blog/2018/6/3/comparing-synchronization-strategies

@interface LIFOLinkedListQueue () {
    dispatch_queue_t _dispatch_queue;
    Node *_head;
    NSInteger _nodeCount;
}
@end

@implementation LIFOLinkedListQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dispatch_queue = dispatch_queue_create("com.CircularQueueUsingLinkedList.ThreadSafe", DISPATCH_QUEUE_SERIAL);
        _nodeCount = 0;
    }
    return self;
}

- (BOOL)enQneue:(id)item
{
    Node *newNode = [[Node alloc] init];
    if (!newNode) {
        return NO;
    }
    newNode.content = item;
    
    dispatch_sync(_dispatch_queue, ^{
        if (!self->_head) {
            self->_head = newNode;
        }
        else {
            newNode.next = self->_head;
            self->_head = newNode;
        }
    });
    
    return YES;
}

- (id)deQueue
{
    id returnItem = _head.content;
    dispatch_sync(_dispatch_queue, ^{
        self->_head = self->_head.next;
    });
    return returnItem;
}

- (void)printQueue
{
    dispatch_sync(_dispatch_queue, ^{
        NSString *string = @"";
        Node *current = self->_head;
        do {
            string = [string stringByAppendingFormat:@"%@", current.content];
            string = [string stringByAppendingString:@" > "];
            current = current.next;
        } while (current);
        string = [string substringToIndex:string.length - 3];
        NSLog(@"%@", string);
    });
}

@end
