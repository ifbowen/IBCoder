//
//  IBController43.m
//  IBCoder1
//
//  Created by Bowen on 2019/4/15.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBController43.h"

/*
 
 https://www.jianshu.com/p/6d7a57794122
 
 0.寄存器工作：计算和寻址
 a.把内存或者I/O端口的数据读取到寄存器中
 b.将寄存器中的数据进行运算(运算只能在寄存器中进行)
 c.将寄存器的内容回写到内存或者I/O端口中
 
 线程是独立调度和分派的基本单位。
 同一进程中的多条线程将共享该进程中的全部系统资源，
 如虚拟地址空间，文件描述符和信号处理等等。
 但同一进程中的多个线程有各自的调用栈（call stack），自己的寄存器环境（register context），自己的线程本地存储（thread-local storage）。
 
 
 1、原子操作：
 原子（atom）本意是“不能被进一步分割的最小粒子”，
 而原子操作（atomic operation）意为"不可被中断的一个或一系列操作"。
 
 2、volatile告诉编译器，计算变量i时，每次强制使用内存中的值，不要使用寄存器中的值，
 它在多处理器开发中保证了共享变量的“可见性”。可见性的意思是当一个线程修改一个共享变量时，另外一个线程能读到这个修改的值。
 
 在多线程环境下，每个线程都有一个独立的寄存器，用于保存当前执行的指令。
 假设我们定义了一个全局变量，每个线程都会访问这个全局变量，这时候线程的
 寄存器可能会存储全量变量的当前值用于后续的访问。当某个线程修改了全局变
 量的值时，系统会立即更新该线程寄存器中对应的值，其他线程并不知道这个全局
 变量已经修改，可能还是从寄存器中获取这个变量的值，这个时候就会存在不一致
 的情况。
 
 针对多线程访问共享变量而且变量还会经常变化的情况，利用volatile类型修饰变量
 是一个很好的选择，如volatile int size = 10; 当多线程访问这个变量时，它会直接从
 size对应的地址访问，而不会从线程对应的寄存器访问，这样就不会出现前面说到的
 同一变量的值在多个线程之间不一致的情况。
 
 a.当写一个volatile变量时，会把该线程对应的本地内存中的变量强制刷新到主内存中去；
 b.这个写会操作会导致其他线程中的缓存无效。
 
 感受：类似于block值锁定
 
 3、atomic，操作原子性 ，atomic 还是属性声明关键字中默认值。
 注意：它没有一个内存“加锁”的概念，而是一个寄存器“加锁（这里其实就是一个防死锁，不让别人继续访问正在修改的value）”的概念，
 保证每次都是寄存器中计算好的数据，而不是返回到内存中已经不用计算的数据。
 
 4、nonatomic：直接从内存中取数值，并没有一个加锁的保护来用于cpu中的寄存器计算Value，它只是单纯的从内存地址中，当前的内存存储的数据结果来进行使用。
 
 */

@interface IBController43 ()

@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;
@property (nonatomic, strong) NSThread *thread3;

@end

@implementation IBController43
{
//    volatile BOOL flag;
    BOOL flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    flag = NO;
    // Do any additional setup after loading the view.
}

/*
 此问题都没有验证
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test];
    [self test1];

}

- (void)test1 {
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        while (1) {
            if (self->flag) {
                NSLog(@"--------");
                break;
            } else {
                NSLog(@"========");
            }
        }
    });
    
    dispatch_async(queue, ^{
        sleep(1);
        self->flag = YES;
        NSLog(@"Flag is %d", self->flag);
    });
}


- (void)test {
    __block int i = 0;
//    __block volatile int i = 0;
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"---1取值：%d", i);
        i++;
        NSLog(@"----1----新值：%d",i);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---2取值：%d", i);
        i++;
        NSLog(@"----2----新值：%d",i);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---3取值：%d", i);
        i++;
        NSLog(@"----3----新值：%d",i++);
    });
}

@end
