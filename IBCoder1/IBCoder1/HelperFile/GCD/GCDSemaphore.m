//
//  GCDSemaphore.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "GCDSemaphore.h"

@interface GCDSemaphore ()

@property (nonatomic, readwrite, strong) dispatch_semaphore_t semaphore;

@end

@implementation GCDSemaphore

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.semaphore = dispatch_semaphore_create(0);
    }
    
    return self;
}

- (instancetype)initWithValue:(long)value {
    
    self = [super init];
    
    if (self) {
        
        self.semaphore = dispatch_semaphore_create(value);
    }
    
    return self;
}

- (instancetype)initWithSemaphore:(dispatch_semaphore_t)semaphore {
    if ((self = [super init]) != nil) {
        self.semaphore = semaphore;
    }
    
    return self;
}

- (BOOL)signal {
    
    return dispatch_semaphore_signal(self.semaphore) != 0;
}

- (void)wait {
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

- (dispatch_semaphore_t)dispatchSemaphore {
    return self.semaphore;
}

@end
