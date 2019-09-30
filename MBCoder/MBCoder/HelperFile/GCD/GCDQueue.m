//
//  GCDQueue.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "GCDQueue.h"

@interface GCDQueue ()

@property (nonatomic) dispatch_queue_t queue;

@end


@implementation GCDQueue

+ (GCDQueue*)main {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_get_main_queue();
    return gcd;
}

+ (GCDQueue*)serial:(NSString*)name {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_queue_create(name.UTF8String, DISPATCH_QUEUE_SERIAL);
    return gcd;
}

+ (GCDQueue*)concurrent:(NSString*)name {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_queue_create(name.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    return gcd;
}

+ (GCDQueue*)queue {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    return gcd;
}

+ (GCDQueue*)high {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    return gcd;
}

+ (GCDQueue*)low {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    return gcd;
}

+ (GCDQueue*)background {
    
    GCDQueue *gcd = [[GCDQueue alloc] init];
    gcd.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    return gcd;
}

- (void)setTarget:(GCDQueue *)gcd {
    
    dispatch_set_target_queue(self.queue, gcd.queue);
}

- (NSString*)label
{
    return @(dispatch_queue_get_label(self.queue));
}

- (dispatch_queue_t)currentQueue {
    return self.queue;
}

- (void)async:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(self.queue, block);
}

- (void)sync:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_sync(self.queue, block);
}

- (void)after:(dispatch_block_t)block delay:(int64_t)delta secs:(BOOL)secs {
    NSParameterAssert(block);
    if (secs) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), self.queue, block);
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.queue, block);
    }
}

- (void)barrier:(dispatch_block_t)block async:(BOOL)async {
    
    NSParameterAssert(block);
    
    if (async) {
        dispatch_barrier_async(self.queue, block);
    } else {
        dispatch_barrier_sync(self.queue, block);
    }
}

- (void)suspend {
    
    dispatch_suspend(self.queue);
}

- (void)resume {
    
    dispatch_resume(self.queue);
}

- (void *)contextForKey:(const void *)key {
    return dispatch_get_specific(key);
}

- (void)setContext:(void *)context forKey:(const void *)key {
    dispatch_queue_set_specific(self.queue, key, context, NULL);
}




@end
