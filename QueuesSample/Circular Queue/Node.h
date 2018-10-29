//
//  Node.h
//  QueuesSample
//
//  Created by NakCheon Jung on 24/10/2018.
//  Copyright © 2018 9folders. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject
@property (strong, nonatomic, nullable) Node *next;
@property (strong, nonatomic) id content;
@end

NS_ASSUME_NONNULL_END
