//
//  GCDGroup.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "GCDGroup.h"

@interface GCDGroup ()

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) GCDQueue *queue;

@end

@implementation GCDGroup

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.group = dispatch_group_create();
        self.queue = [GCDQueue queue];
    }
    return self;
}

+ (GCDGroup*)group {
    
    return  [[GCDGroup alloc] init];
}

- (void)async:(dispatch_block_t)block {

    dispatch_group_async(self.group, self.queue.currentQueue, block);
}

- (void)async:(dispatch_block_t)block queue:(GCDQueue *)object {
    
    dispatch_group_async(self.group, object.currentQueue, block);
}

- (void)notify:(dispatch_block_t)block {
    
    dispatch_notify(self.group, self.queue.currentQueue, block);
}

- (void)notify:(dispatch_block_t)block queue:(GCDQueue *)object {
    
    dispatch_notify(self.group, object.currentQueue, block);
}


- (void)enter {
    
    dispatch_group_enter(self.group);
}

- (void)leave {
    
    dispatch_group_leave(self.group);
}

- (void)wait {
    
    dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_group_wait(self.group, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

- (void)suspend
{
    dispatch_suspend(self.group);
}

- (void)resume
{
    dispatch_resume(self.group);
}



@end
