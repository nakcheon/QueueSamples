//
//  NSArrayQueue.m
//  QueuesSample
//
//  Created by NakCheon Jung on 22/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import "NSArrayQueue.h"

// 참고 thread safe operaions in iOS: http://www.lukeparham.com/blog/2018/6/3/comparing-synchronization-strategies
// 참고 환영큐: https://www.geeksforgeeks.org/circular-queue-set-1-introduction-array-implementation/

@interface NSArrayQueue () {
    NSMutableArray *_queue;
}

@end

@implementation NSArrayQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)enQneue:(id)item
{
    @synchronized (self) {
        [_queue addObject:item];
    }
    return YES;
}

- (id)deQueue
{
    @synchronized (self) {
        if (_queue.count == 0) {
            return nil;
        }
        else {
            id item = _queue.firstObject;
            [_queue removeObjectAtIndex:0];
            return item;
        }
    }
}

- (void)printQueue
{
    @synchronized (self) {
        __block NSString *string = @"";
        [self->_queue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            string = [string stringByAppendingFormat:@"%@", obj];
            string = [string stringByAppendingString:@" > "];
        }];
        string = [string substringToIndex:string.length - 3];
        NSLog(@"%@", string);
    };
}

@end
