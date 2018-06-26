//
//  GCDGroup.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDQueue.h"

@interface GCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

+ (instancetype)group;

- (void)async:(dispatch_block_t)block;
- (void)async:(dispatch_block_t)block queue:(GCDQueue *)object;
- (void)notify:(dispatch_block_t)block;
- (void)notify:(dispatch_block_t)block queue:(GCDQueue *)object;

- (void)enter;
- (void)leave;

- (void)wait;
- (BOOL)wait:(int64_t)delta;

- (void)suspend;
- (void)resume;



@end
