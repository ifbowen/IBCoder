//
//  IBRunLoopLoad.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/7.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBRunLoopLoad.h"

/*
 C语言中在函数名或关键字前加下划线
 一般情况是标识该函数或关键字是自己内部使用的，与提供给外部的接口函数或关键字加以区分。
 这只是一种约定，实际你非要把这些函数或关键字提供给外部使用，语法上也没有限制。
 */

@interface IBRunLoopLoad ()

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation IBRunLoopLoad

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maximumQueueLength = 30;
        _tasks = [NSMutableArray array];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_timerFired) userInfo:nil repeats:YES];

    }
    return self;
}

+ (instancetype)sharedRunLoop {
    static IBRunLoopLoad *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IBRunLoopLoad alloc] init];
        [self _registerRunLoopObserver:instance];
    });
    return instance;
}

- (void)addTask:(RunLoopTaskBlock)block{
    [self.tasks addObject:block];
    if (self.tasks.count > self.maximumQueueLength) {
        [self.tasks removeObjectAtIndex:0];
    }
}

- (void)removeAllTasks {
    [self.tasks removeAllObjects];
}

+ (void)_registerRunLoopObserver:(IBRunLoopLoad *)runLoopLoad {
    static CFRunLoopObserverRef defaultModeObserver;
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {0, ( __bridge void *)(runLoopLoad), &CFRetain, &CFRelease, NULL};
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, NSIntegerMax - 999, &_runloopTaskCallBack, &context);
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
    CFRelease(defaultModeObserver);
    
}

static void _runloopTaskCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    IBRunLoopLoad *runloopLoad = (__bridge IBRunLoopLoad *)info;
    
    if (runloopLoad.tasks.count > 0) {
        //获取一次数组里面的任务并执行
        RunLoopTaskBlock block = runloopLoad.tasks.firstObject;
        block();
        [runloopLoad.tasks removeObjectAtIndex:0];
    }
}

//此方法主要是利用计时器事件保持runloop处于循环中，不用做任何处理
- (void)_timerFired {
    //We do nothing here
}


@end
