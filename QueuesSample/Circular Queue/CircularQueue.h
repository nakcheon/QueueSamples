//
//  CircularQueue.h
//  QueuesSample
//
//  Created by NakCheon Jung on 22/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArrayQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircularQueue : NSArrayQueue

- (BOOL)enQneue:(id)item;
- (id)deQueue;
- (void)printQueue;

@end

NS_ASSUME_NONNULL_END
