//
//  ViewController.m
//  QueuesSample
//
//  Created by NakCheon Jung on 22/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import "ViewController.h"
#import "NSArrayQueue.h"
#import "CircularQueueUsingLinkedList.h"
#import "LIFOLinkedListQueue.h"
#import "FIFOLinkedListQueue.h"
#import "CircularQueue.h"
#import "CircularQueueAtomic.h"

@interface ViewController ()

- (BOOL)_testCircularQeue:(NSArrayQueue *)queue;
- (BOOL)_testLinkedListCircularQeue:(CircularQueueUsingLinkedList *)queue;
- (BOOL)_testLIFOLinkedListQueue:(LIFOLinkedListQueue *)queue;
- (BOOL)_testFIFOLinkedListQueue:(FIFOLinkedListQueue *)queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        NSArrayQueue *queue = [[NSArrayQueue alloc] init];
        [self testCircularQueue:queue];
    }
    
    {
        CircularQueue *queue = [[CircularQueue alloc] init];
        [self testCircularQueue:queue];
    }
    
    {
        CircularQueueAtomic *queue = [[CircularQueueAtomic alloc] init];
        [self testCircularQueue:queue];
    }
    
//    {
//        CircularQueueUsingLinkedList *queue = [[CircularQueueUsingLinkedList alloc] init];
//        dispatch_group_t group = dispatch_group_create();
//        for (NSInteger i = 0.0; i < 10000; ++i) {
//            __weak typeof(self) weakSelf = self;
//            dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
//                __strong typeof(weakSelf) strongSelf = weakSelf;
//                if (!strongSelf) {
//                    return;
//                }
//                [strongSelf _testLinkedListCircularQeue:queue];
//            });
//        }
//    }
    
//        {
//            LIFOLinkedListQueue *queue = [[LIFOLinkedListQueue alloc] init];
//            dispatch_group_t group = dispatch_group_create();
//            for (NSInteger i = 0.0; i < 10000; ++i) {
//                __weak typeof(self) weakSelf = self;
//                dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
//                    __strong typeof(weakSelf) strongSelf = weakSelf;
//                    if (!strongSelf) {
//                        return;
//                    }
//                    [strongSelf _testLIFOLinkedListQueue:queue];
//                });
//            }
//        }
    
//    {
//        FIFOLinkedListQueue *queue = [[FIFOLinkedListQueue alloc] init];
//        dispatch_group_t group = dispatch_group_create();
//        for (NSInteger i = 0.0; i < 10000; ++i) {
//            __weak typeof(self) weakSelf = self;
//            dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
//                __strong typeof(weakSelf) strongSelf = weakSelf;
//                if (!strongSelf) {
//                    return;
//                }
//                [strongSelf _testFIFOLinkedListQueue:queue];
//            });
//        }
//    }
    
    FIFOLinkedListQueue *queue = [[FIFOLinkedListQueue alloc] init];
    [self _testFIFOLinkedListQueue:queue];
}

- (void)testCircularQueue:(NSArrayQueue *)queue
{
    CFTimeInterval startTime = CACurrentMediaTime();
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0.0; i < 100; ++i) {
        __weak typeof(self) weakSelf = self;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            [strongSelf _testCircularQeue:queue];
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"time = %@", @(endTime - startTime));
}

- (BOOL)_testCircularQeue:(NSArrayQueue *)queue
{
    for (NSInteger i = 0; i < 200; ++i) {
        [queue enQneue:@(14)];
        [queue enQneue:@(22)];
        [queue enQneue:@(9)];
        [queue enQneue:@(20)];
        [queue enQneue:@(5)];
    }
    
    for (NSInteger i = 0; i < 200; ++i) {
        [queue deQueue];
        [queue deQueue];
        [queue deQueue];
        [queue deQueue];
        [queue deQueue];
    }
    
    //[queue printQueue];
    
    return YES;
}

- (BOOL)_testLinkedListCircularQeue:(CircularQueueUsingLinkedList *)queue
{
    [queue deQueue];
    
    [queue enQneue:@(14)];
    [queue enQneue:@(22)];
    [queue enQneue:@(13)];
    [queue enQneue:@(-6)];
    [queue deQueue];
    [queue deQueue];
    [queue enQneue:@(9)];
    [queue enQneue:@(20)];
    [queue enQneue:@(5)];
    
    [queue printQueue];
    
    return YES;
}

- (BOOL)_testLIFOLinkedListQueue:(LIFOLinkedListQueue *)queue
{
    [queue deQueue];
    
    [queue enQneue:@(14)];
    [queue enQneue:@(22)];
    [queue enQneue:@(13)];
    [queue enQneue:@(-6)];
    [queue deQueue];
    [queue deQueue];
    [queue enQneue:@(9)];
    [queue enQneue:@(20)];
    [queue enQneue:@(5)];
    
    [queue printQueue];
    
    return YES;
}

- (BOOL)_testFIFOLinkedListQueue:(FIFOLinkedListQueue *)queue
{
    [queue deQueue];
    
    [queue enQneue:@(14)];
    [queue enQneue:@(22)];
    [queue enQneue:@(13)];
    [queue enQneue:@(-6)];
    [queue deQueue];
    [queue deQueue];
    [queue enQneue:@(9)];
    [queue enQneue:@(20)];
    [queue enQneue:@(5)];
    
    [queue printQueue];
    
    return YES;
}

@end
