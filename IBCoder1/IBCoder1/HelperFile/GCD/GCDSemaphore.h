//
//  GCDSemaphore.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDSemaphore : NSObject

@property (nonatomic, readonly, strong) dispatch_semaphore_t dispatchSemaphore;

- (instancetype)initWithValue:(long)value;
- (instancetype)initWithSemaphore:(dispatch_semaphore_t)semaphore;

- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(int64_t)delta;


@end
