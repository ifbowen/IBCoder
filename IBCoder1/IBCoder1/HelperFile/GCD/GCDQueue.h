//
//  GCDQueue.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDQueue : NSObject

@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) dispatch_queue_t currentQueue;

+ (instancetype)serial:(NSString*)name;
+ (instancetype)concurrent:(NSString*)name;
+ (instancetype)main;
+ (instancetype)queue;
+ (instancetype)high;
+ (instancetype)low;
+ (instancetype)background;

- (void)async:(dispatch_block_t)block;
- (void)sync:(dispatch_block_t)block;

- (void)after:(dispatch_block_t)block delay:(int64_t)delta secs:(BOOL)secs;
- (void)barrier:(dispatch_block_t)block async:(BOOL)async;

- (void)suspend;
- (void)resume;

- (void *)contextForKey:(const void *)key;
- (void)setContext:(void *)context forKey:(const void *)key;
//给自己的Queue设置优先级
- (void)setTarget:(GCDQueue *)gcd;

@end
