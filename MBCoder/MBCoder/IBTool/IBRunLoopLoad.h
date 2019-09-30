//
//  IBRunLoopLoad.h
//  IBCoder1
//
//  Created by Bowen on 2018/5/7.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RunLoopTaskBlock)(void);

@interface IBRunLoopLoad : NSObject

@property (nonatomic, assign) NSUInteger maximumQueueLength;

+ (instancetype)sharedRunLoop;

- (void)addTask:(RunLoopTaskBlock)block;

- (void)removeAllTasks;

@end
