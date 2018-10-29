//
//  LIFOLinkedListQueue.h
//  QueuesSample
//
//  Created by NakCheon Jung on 24/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LIFOLinkedListQueue : NSObject

- (BOOL)enQneue:(id)item;
- (id)deQueue;
- (void)printQueue;


@end

NS_ASSUME_NONNULL_END
