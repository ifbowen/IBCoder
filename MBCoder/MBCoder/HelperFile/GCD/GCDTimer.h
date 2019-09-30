//
//  GCDTimer.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDQueue.h"

@interface GCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

+ (instancetype)timer;
- (instancetype)initInQueue:(GCDQueue *)queue;

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)event:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeInterval:(uint64_t)interval;

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay;
- (void)event:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeInterval:(uint64_t)interval delay:(uint64_t)delay;

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs;
- (void)event:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeIntervalWithSecs:(float)secs;

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;
- (void)event:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;

- (void)start;
- (void)destroy;


@end
