//
//  IBGroup2Controller28.m
//  MBCoder
//
//  Created by BowenCoder on 2020/8/1.
//  Copyright © 2020 inke. All rights reserved.
//

#import "IBGroup2Controller28.h"
#import <pthread.h>

@interface IBGroup2Controller28 ()

@end

@implementation IBGroup2Controller28

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)mutexLock{
    //pthread_mutex
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex,NULL);
    pthread_mutex_lock(&mutex);
    pthread_mutex_unlock(&mutex);

    //NSLock
    NSLock *lock = [[NSLock alloc] init];
    lock.name = @"lock";
    [lock lock];
    [lock unlock];
    
    //synchronized
    @synchronized (self) {
        
    }
    // 1
}

- (void)RecursiveLock{
    NSRecursiveLock *lock = [NSRecursiveLock alloc];
    [lock lock];
    [lock lock];
    
    [lock unlock];
    [lock unlock];
}

- (void)conditionLock{
    __block NSCondition *condition;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        condition = [[NSCondition alloc] init];
        [condition wait];
        NSLog(@"finish----");
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:5.0];
        [condition signal];
    });
}

- (void)semaphore{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"semaphoreFinish---");
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:5.0];
        dispatch_semaphore_signal(semaphore);
    });
}



/*
 
 自旋锁
 NSSpinLock
 信号量
 dispatch_semaphore
 互斥锁
 p_thread_mutex,NSLock,@synthronized
 条件锁
 NSConditionLock
 递归锁
 NSRecursiveLock
 
 自旋锁问题
 如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，
 它会处于 spin lock 的忙等状态从而占用大量 CPU。此时低优先级线程无法与高优先级线程争夺 CPU 时间，
 从而导致任务迟迟完不成、无法释放 lock，这就是优先级反转
 
 自旋锁，互斥锁的选择

 什么情况使用自旋锁比较划算？
 预计线程等待锁的时间很短
 加锁的代码（临界区）经常被调用，但竞争情况很少发生
 CPU资源不紧张
 多核处理器

 什么情况使用互斥锁比较划算？
 预计线程等待锁的时间较长，线程处于休眠状态
 单核处理器
 临界区有IO操作
 临界区代码复杂或者循环量大
 临界区竞争非常激烈
 
 */

@end
