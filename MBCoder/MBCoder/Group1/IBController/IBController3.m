//
//  IBController3.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/25.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController3.h"

@interface IBController3 ()

@property(nonatomic,assign) int filmTickets;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSThread *thread;

@end

/*
 进程：执行中的应用程序【一个应用程序可以有很多进程(网游双开)，在iOS中一个app只有一个进程。】
 资源分配最小单元
 线程：进程中的一个执行序列，执行调度的最小单元（在iOS上一般开启3~5个线程）
 
 线程与进程的区别：
 a.地址空间和其它资源：进程间拥有独立内存，进程是资源分配的基本单位；
   线程隶属于某一进程，且同一进程的各线程间共享内存（资源），线程是cpu调度的基本单位。
 b.通信：进程间相互独立，通信困难，常用的方法有：管道，信号，套接字，共享内存，消息队列等；
   线程间可以直接读写进程数据段（如全局变量）来进行通信——需要进程同步和互斥手段的辅助，以保证数据的一致性。
 c.调度和切换：线程上下文切换比进程上下文切换要快。进程间切换要保存上下文，加载另一个进程；
   而线程则共享了进程的上下文环境，切换更快。
 
 一、简介
 1.什么是GCD
 全称是Grand Central Dispatch，可译为“牛逼的中枢调度器”
 纯C语言，提供了非常多强大的函数
 
 2.GCD的优势
 GCD是苹果公司为多核的并行运算提出的解决方案
 GCD会自动利用更多的CPU内核（比如双核、四核）
 GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
 
 二、任务和队列
 1.GCD中有2个核心概念
 任务：执行什么操作
 队列：用来存放任务
 
 2.GCD的使用就2个步骤
 定制任务
 确定想做的事情
 
 3.将任务添加到队列中
 GCD会自动将队列中的任务取出，放到对应的线程中执行
 任务的取出遵循队列的FIFO原则：先进先出，后进后出
 
 三、执行任务
 1.GCD中有2个用来执行任务的函数
 用同步的方式执行任务
 dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
 queue：队列
 block：任务
 
 2.用异步的方式执行任务
 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 
 3.同步和异步的区别
 同步：只能在当前线程中执行任务，不具备开启新线程的能力
 异步：可以在新的线程中执行任务，具备开启新线程的能力
 
 四、队列的类型
 1.GCD的队列可以分为2大类型
 并发队列（Concurrent Dispatch Queue）
 可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
 并发功能只有在异步（dispatch_async）函数下才有效
 
 2.串行队列（Serial Dispatch Queue）
 让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）
 
 五、容易混淆的术语
 1.有4个术语比较容易混淆：同步、异步、并发、串行
 同步和异步主要影响：能不能开启新的线程
 同步：在当前线程中执行任务，不具备开启新线程的能力
 异步：在新的线程中执行任务，具备开启新线程的能力
 
 2.并发和串行主要影响：任务的执行方式
 并发：多个任务并发（同时）执行
 串行：一个任务执行完毕后，再执行下一个任务
 
 六、并发队列
 1.GCD默认已经提供了全局的并发队列，供整个应用使用，不需要手动创建
 使用dispatch_get_global_queue函数获得全局的并发队列
 dispatch_queue_t dispatch_get_global_queue(
 dispatch_queue_priority_t priority, // 队列的优先级
 unsigned long flags); // 此参数暂时无用，用0即可
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 获得全局并发队列
 
 2.全局并发队列的优先级
 #define DISPATCH_QUEUE_PRIORITY_HIGH 2 // 高
 #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0 // 默认（中）
 #define DISPATCH_QUEUE_PRIORITY_LOW (-2) // 低
 #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN // 后台
 
 七、串行队列
 1.GCD中获得串行有2种途径
 使用dispatch_queue_create函数创建串行队列
 dispatch_queue_t
 dispatch_queue_create(const char *label, // 队列名称
 dispatch_queue_attr_t attr); // 队列属性，一般用NULL即可
 dispatch_queue_t queue = dispatch_queue_create("cn.itcast.queue", NULL); // 创建
 dispatch_release(queue); // 非ARC需要释放手动创建的队列
 
 2.使用主队列（跟主线程相关联的队列）
 主队列是GCD自带的一种特殊的串行队列
 放在主队列中的任务，都会放到主线程中执行
 使用dispatch_get_main_queue()获得主队列
 dispatch_queue_t queue = dispatch_get_main_queue();
 
 八、各种队列的执行效果
 注意
 使用sync函数往当前串行队列中添加任务，会卡住当前的串行队列
 
 九、线程间通信示例
 1.从子线程回到主线程
 dispatch_async(
 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 // 执行耗时的异步操作...
 dispatch_async(dispatch_get_main_queue(), ^{
 // 回到主线程，执行UI刷新操作
 });
 });
 2、performSelector: onThread:
 3、[[NSOperationQueue mainQueue] addOperation: ];
 
 十、延时执行
 iOS常见的延时执行有2种方式
 调用NSObject的方法
 [self performSelector:@selector(run) withObject:nil afterDelay:2.0];
 // 2秒后再调用self的run方法
 
 使用GCD函数
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 // 2秒后执行这里的代码... 在哪个线程执行，跟队列类型有关
 
 });
 
 十一、一次性代码
 使用dispatch_once函数能保证某段代码在程序运行过程中只被执行1次
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 // 只执行1次的代码(这里面默认是线程安全的)
 });
 
 十二、队列组
 1.有这么1种需求
 首先：分别异步执行2个耗时的操作
 其次：等2个异步操作都执行完毕后，再回到主线程执行操作
 
 2.如果想要快速高效地实现上述需求，可以考虑用队列组
 dispatch_group_t group =  dispatch_group_create();
 dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 // 执行1个耗时的异步操作
 });
 dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 // 执行1个耗时的异步操作
 });
 dispatch_group_notify(group, dispatch_get_main_queue(), ^{
 // 等前面的异步操作都执行完毕后，回到主线程...
 });
 
 十三、Core Foundation
 Foundation : OC
 Core Foundation : C
 Foundation和Core Foundation可以相互转化
 
 NSString *str = @"123";
 CFStringRef str2 = (__bridge CFStringRef)str;
 NSString *str3 = (__bridge NSString *)(str2);
 
 CFArrayRef --- NSArray
 CFDictionaryRef --- NSDirectory
 CFNumberRef --- NSNumber
 
 凡是函数名中带有create\copy\retain\new等字眼，都应该再不需要的时候进行release
 GCD的数据类型在ARC环境下不需要release
 CF（Core Foundation）的数据类型在ARC环境下还需要release
 
 Core Foundation中手动创建的数据类型，需要手动释放
 CFArrayRef array = CFArrayCreate(NULL, NULL, 10, NULL);
 CFRelease(array);
 
 CGPathRef path = CGPathCreateMutable();
 CGPathRelease(path);
 
 
 注意千万分清：主线程和主队列概念
 
 十四、线程安全
 1、资源竞争---->加锁、在串行队列中执行
 2、线程死锁---->任务之间相互等待
    判断是否发生死锁的最好方法就是看有没有在串行队列(主队列)中同步向这个队列添加任务。
 
 十五、怎么判断线程是否结束？
 1、NSThread创建的线程： 使用performSelector: onThread:方法，给线程添加事件看是否运行
 2、GCD的group：原理就是利用dispatch_group_async执行完queue会执行dispatch_group_notify回调
 3、dispatch_barrier_async：一般使用dispatch_barrier_async, 会让barrier之前的线程执行完成之后才会执行barrier后面的操作
 4、NSOperationQueue：用到addDependency: waitUntilFinished: 方法，如果是YES，必须等到queue中所有Operation执行完毕之后, 才会继续执行。所以会卡住当前线程
 
 十六、杀死一个线程
 1、GCD线程：定义外部变量，用于标记block是否需要取消，如果要取消直接返回return
 2、dispatch_block_cancel也只能取消尚未执行的任务，对正在执行的任务不起作用
 
 十七、performSelector:withObject:afterDelay: 内部大概是怎么实现的，有什么注意事项么？
 创建一个定时器,时间结束后系统会使用runtime通过方法名称(Selector本质就是方法名称)去方法列表中找到对应的方法实现并调用方法
 注意事项
 调用performSelector:withObject:afterDelay:方法时,先判断希望调用的方法是否存在respondsToSelector:
 这个方法是异步方法,必须在主线程调用,在子线程调用永远不会调用到想调用的方法
 
 十八、进程死锁
 死锁，是指多个进程在运行过程中因争夺资源而照成的一种僵局。当进程处于这种僵持状态时，若无外力作用，它们都将无法再向前推进。
 （1）竞争资源。当系统中供多个进程共享的资源如打印机、公用队列等，其数目不足以满足诸进程的需要时，会引起诸进程对资源的竞争而产生死锁。
 （2）进程间推进顺序非法。进程在运行过程中，请求和释放资源的顺序不当，也同样会产生进程死锁。
 
 当然死锁的产生是必须要满足一些特定条件的：
 1.互斥条件：进程对于所分配到的资源具有排它性，即一个资源只能被一个进程占用，直到被该进程释放
 2.请求和保持条件：一个进程因请求被占用资源而发生阻塞时，对已获得的资源保持不放。
 3.不剥夺条件：任何一个资源在没被该进程释放之前，任何其他进程都无法对他剥夺占用
 4.循环等待条件：当发生死锁时，所等待的进程必定会形成一个环路（类似于死循环），造成永久阻塞。
 
 十九、读者，写者问题
 读者优先:
 1.写者、读者互斥访问文件资源。
 2.多个读者可以同时访问文件资源。
 3.只允许一个写者访问文件资源。
 具体实现:
 1.设置信号量fileSrc实现读写者对临界资源的访问。
 2.设置计数器readCount来统计访问临界资源的读者数目，设置信号量readCountSignal完成对readCount计数器资源的互斥访问。
 
 写者优先:
 1.写者线程的优先级高于读者线程。
 2.当有写者到来时应该阻塞读者线程的队列。
 3.当有一个写者正在写时或在阻塞队列时应当阻塞读者进程的读操作，直到所有写者进程完成写操作时放开读者进程。
 4.当没有写者进程时读者进程应该能够同时读取文件。
 具体实现:
 1.通过添加信号量read实现写者到来时能够打断读者进程。
 2.设置信号量fileSrc实现读写者对临界资源的访问。
 3.设置计数器writeCount来统计当前阻塞的写者进程的数目，设置信号量writeCountSignal完成对writeCount计数器资源的互斥访问。
 4.设置计数器readCount来统计访问临界资源的读者数目，设置信号量readCountSignal完成对readCount计数器资源的互斥访问。
 
 公平竞争：
 1.优先级相同。
 2.写者、读者互斥访问。
 3.只能有一个写者访问临界区。
 4.可以有多个读者同时访问临界资源。
 具体实现：
 1.设置file信号量实现对临界资源的互斥访问。
 2.设置计数器readCount实现多个读者访问临界资源，通过设置信号量readCountSignal实现对readCount计数器的互斥访问。
 3.设置信号量keySignal实现读者和写者的公平竞争（令牌）。
 4.设置信号量OneSignal实现只有读者队列或写者阻塞在keySignal（对令牌资源的访问控制）。
 
 二十、NSOperation 与 GCD 的主要区别？
 1. GCD 的核心是 C 语言写的系统服务，执行和操作简单高效
    NSOperation 是对 GCD 更高层次的抽象，这是他们之间最本质的区别。因此如果希望自定义任务，建议使用 NSOperation；

 2. 依赖关系，NSOperation 可以设置两个 NSOperation 之间的依赖，第二个任务依赖于第一个任务完成执行，
            GCD 无法设置依赖关系，不过可以通过dispatch_barrier_async来实现这种效果；

 3. KVO(键值对观察)，NSOperation 和容易判断 Operation 当前的状态(是否执行，是否取消)，对此 GCD 无法通过 KVO 进行判断；

 4. 优先级，NSOperation 可以设置自身的优先级，但是优先级高的不一定先执行，
          GCD 只能设置队列的优先级，无法在执行的 block 设置优先级；

 5. 继承，NSOperation 是一个抽象类，实际开发中常用的两个类是 NSInvocationOperation 和 NSBlockOperation ，同样我们可以自定义 NSOperation，
        GCD 执行任务可以自由组装，没有继承那么高的代码复用度；

 6. 效率，直接使用 GCD 效率确实会更高效，NSOperation 会多一点开销，
         但是通过 NSOperation 可以获得依赖，优先级，继承，键值对观察这些优势，相对于多的那么一点开销确实很划算
 7、NSOperation可以设置暂停，挂起等操作。

 */

@implementation IBController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.filmTickets = 100;
    self.lock = [[NSLock alloc] init];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"-------------------------------------");
    
//    [self test0];
//    [self test1];
//    [self test1_1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test4_1];
//    [self test4_2];
//    [self test4_3];
//    [self test5];
//    [self test6];
//    [self test7];
//    [self test8];
//    [self test9];
//    [self test9_1];
//    [self test9_21];
//    [self test9_2];
//    [self test9_3];
//    [self test10];
//    [self test11];
//    [self test12];
//    [self test13];
//    [self test14];
//    [self test15];
    [self test16];
    NSLog(@"++++++++++++++++++++++++++++++++++++");
    
}

- (void)test16 {
    dispatch_queue_t queue = dispatch_queue_create("b", DISPATCH_QUEUE_SERIAL); // 12345
//    dispatch_queue_t queue = dispatch_queue_create("b", DISPATCH_QUEUE_CONCURRENT); //23145
    
    dispatch_async(queue, ^{
//        sleep(3);
        NSLog(@"1");
        dispatch_sync(queue, ^{
            NSLog(@"2");
        });
    });
    
    NSLog(@"a");
    

    
    NSLog(@"b");
    
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    
    NSLog(@"c");
    
    dispatch_sync(queue, ^{
        sleep(5);
        NSLog(@"4");
    });
    
    NSLog(@"d");
    
    dispatch_async(queue, ^{
        NSLog(@"5");
    });
    
}

//解束正在执行的任务
- (void)test15 {
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(work) object:nil];
    [self.thread start];
    sleep(3);
    NSLog(@"结束线程");
    [self.thread cancel];//结束未执行的任务或者标记正在执行的任务要取消
}

- (void)work {
    for (long i=0; i<10; i++) {
        NSLog(@"i:%ld",i);
        sleep(1);
        if (self.thread.isCancelled) {
            [NSThread exit];
        }
    };
}

/**
 NSOperationQueue主线程更新UI和取消没有执行的任务
 */
- (void)test14 {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 4;
    [operationQueue addOperationWithBlock:^{
        NSLog(@"任务一");
    }];
    NSOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    NSOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"主线程更新UI......%@",[NSThread currentThread]);;
    }];
    [op addDependency:operationQueue.operations.firstObject];
    [op1 addDependency:op];
    [operationQueue addOperation:op];
    [[NSOperationQueue mainQueue] addOperation:op1];
    
//    [operationQueue cancelAllOperations]; //移除队列里面所有的操作，但正在执行的操作无法移除
//    operationQueue.suspended = YES; //正在执行的任务无法挂起
//    NSLog(@"结束");
}

- (void)run {
    NSLog(@"----耗时操作开始----");
    for (long i=0; i<10; i++) {
        NSLog(@"j:%ld",i);
        sleep(1);
        if (i == 6) {
            
            return;
        }
    };
    NSLog(@"----耗时操作完成----");
}

//结束没有执行的线程
- (void)test13 {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        NSLog(@"--1--");
    });
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"---2---");
    });
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        for (long i=0; i<100000; i++) {
            NSLog(@"i:%ld",i);
            sleep(1);
        };
    });
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    dispatch_block_cancel(block2);//dispatch_block_cancel也只能取消尚未执行的任务，对正在执行的任务不起作用
}

//GCD结束正在执行的线程
- (void)test12 {
    __block BOOL gcdFlag = NO;

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        for (long i=0; i<100000; i++) {
            NSLog(@"i:%ld",i);
            if (i == 10) {
                gcdFlag = YES;
            }
            sleep(1);
            if (gcdFlag==YES) {
                NSLog(@"收到gcd停止信号");
                return;
            }
        };
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"结束");
    });
    
}

static dispatch_queue_t safe_queue() {
    static dispatch_queue_t safe_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safe_queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    });
    return safe_queue;
}

static void create_task_safely(dispatch_block_t block) {
    dispatch_sync(safe_queue(), block);
}

- (void)sellTickets {
    
    //方法二 放在串行队列中
    create_task_safely(^{
        self.filmTickets -= 1;
        NSLog(@"剩余票数----%d----",self.filmTickets);
    });
    
//    方法一
//    [self.lock lock];
//    [NSThread sleepForTimeInterval:0.02];
//    self.filmTickets -= 1;
//    NSLog(@"----%d----",self.filmTickets);
//    [self.lock unlock];
}

//测试锁
- (void)test11 {
    
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i< self.filmTickets; i++) {
        dispatch_async(queue, ^{
            [self sellTickets];
        });
    }
}

/*
 分析：
 线程运行
 */
- (void)test10 {
    dispatch_queue_t queue = dispatch_queue_create("b", DISPATCH_QUEUE_SERIAL);
    NSLog(@"----1----%@",[NSThread currentThread]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 10; i ++) {
            NSLog(@"----2----%@",[NSThread currentThread]);
        }
    });
    dispatch_queue_t queue1 = dispatch_queue_create("b", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue1, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
        NSLog(@"----5----%@",[NSThread currentThread]);
//        dispatch_sync(queue, ^{
//            NSLog(@"----特例----%@",[NSThread currentThread]);
//        });
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----6----%@",[NSThread currentThread]);
    });
    NSLog(@"----7----%@",[NSThread currentThread]);
    
    NSLog(@"1111111111111111111111111111111111111");
}

/**
 不同串行队列，不死锁
 */
- (void)test9_3 {
    NSLog(@"----begin1----");
    dispatch_queue_t queue = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue1 = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"----sync2----%@",[NSThread currentThread]);
        });
        dispatch_sync(queue1, ^{
            NSLog(@"----sync3----%@",[NSThread currentThread]);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"----sync4----%@",[NSThread currentThread]);
        });
        NSLog(@"----async5----%@",[NSThread currentThread]);
    });
    NSLog(@"----end6----");
}

- (void)test9_21 {
    NSLog(@"----begin1----");
    dispatch_queue_t queue = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"----sync2----%@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"----sync3----%@",[NSThread currentThread]);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"----sync4----%@",[NSThread currentThread]);
        });
        NSLog(@"----async5----%@",[NSThread currentThread]);
    });
    NSLog(@"----end6----");
}

/**
 考察：sync3死锁
 */
- (void)test9_2 {
    NSLog(@"----begin1----");
    dispatch_queue_t queue = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue1 = dispatch_queue_create("234", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("345", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        dispatch_sync(queue1, ^{
            NSLog(@"----sync1----%@",[NSThread currentThread]);
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"----sync2----%@",[NSThread currentThread]);
        });
        dispatch_sync(queue, ^{
            NSLog(@"----sync3----%@",[NSThread currentThread]);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"----sync4----%@",[NSThread currentThread]);
        });
        dispatch_sync(queue2, ^{
            NSLog(@"----sync5----%@",[NSThread currentThread]);
        });
        NSLog(@"----async6----%@",[NSThread currentThread]);
    });
    NSLog(@"----end6----");
}

/**
 考察：sync2立马到主线程中执行
 */
- (void)test9_1 {
    NSLog(@"----begin1----");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"----sync1----%@",[NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"----sync2----%@",[NSThread currentThread]);
        });
        dispatch_sync(queue, ^{
            NSLog(@"----sync3----%@",[NSThread currentThread]);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"----sync4----%@",[NSThread currentThread]);
        });
        for (int i = 0; i < 10; i++) {
            NSLog(@"----async5----%@",[NSThread currentThread]);
        }
    });
    for (int i = 0; i < 10; i++) {
        NSLog(@"----end6----");
    }
}

/**
 同步主队列 --- 不能用(死锁)
 在主线程中执行
 理解：主队列在同步任务的条件下,必须主线程空闲的时候,才可以添加任务到队列中
 */
- (void)test9 {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"----1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
    });
}

/**
 * sync（同步） --串行队列
 * 会不会创建线程：不会
 * 线程的执行方法：串行（一个任务执行完毕后，再执行下一个任务）
 * 在主线程中执行串行队列，完成后回到主线程在执行主队列
 */
- (void)test8 {
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"----1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
    });
}

/**
 * sync（同步） --并发队列
 * 会不会创建线程：不会,在主线程中运行
 * 任务的执行方式：串行（一个任务执行完毕后，再执行下一个任务）
 * 并发队列失去并发功能
 * 在主线程中执行并发队列，完成后回到主线程执行主队列
 */
- (void)test7 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"----1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
    });
}

/**
 * async（异步） --主队列（很常用）（特殊）
 * 会不会创建线程：不会
 * 任务的执行方式：串行
 * 一般用在线程之间的通讯
 * 理解：异步主队列，先把任务添加到主队列中，等主线程空闲执行任务
 */
- (void)test6 {
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSLog(@"----1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
    });
}

/**
 * async（异步） --串行队列（有时用）
 * 会不会创建线程：会，创建一条
 * 线程的执行方法：串行（一个任务执行完毕后，再执行下一个任务）
 */
- (void)test5 {
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"----1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
    });

}



/**
 * async（异步） --并发队列（最常用）
 * 会不会创建线程：会，并且创建多条线程，有复用执行完的线程可能
 * 任务的执行方式：并发执行
 */
- (void)test4 {
    
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"----1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----3----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4----%@",[NSThread currentThread]);
    });
}


/**
 三个线程顺序重复执行,dispatch_semaphore_t 卡住 主线程
 */
- (void)test4_2 {
    
    dispatch_semaphore_t sema1 = dispatch_semaphore_create(1);
    dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
    dispatch_semaphore_t sema3 = dispatch_semaphore_create(0);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [[NSThread currentThread] setName:@"thread1"];
        while (1) {
            dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
            NSLog(@"----1----%@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema2);
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [[NSThread currentThread] setName:@"thread2"];
        while (1) {
            dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
            NSLog(@"----2----%@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema3);
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [[NSThread currentThread] setName:@"thread3"];
        while (1) {
            dispatch_semaphore_wait(sema3, DISPATCH_TIME_FOREVER);
            NSLog(@"----3----%@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema1);
        }
    }];

    [queue addOperations:@[op1, op2, op3] waitUntilFinished:NO];
}

- (void)test4_3 {
    
    __block BOOL thread1 = YES;
    __block BOOL thread2 = NO;
    __block BOOL thread3 = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("bowen", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [[NSThread currentThread] setName:@"thread1"];
        while (1) {
            if (thread1) {
                thread1 = NO;
                NSLog(@"----1----%@",[NSThread currentThread]);
                thread2 = YES;
            }
        }
    });
    
    dispatch_async(queue, ^{
        [[NSThread currentThread] setName:@"thread2"];
        while (1) {
            if (thread2) {
                thread2 = NO;
                NSLog(@"----2----%@",[NSThread currentThread]);
                thread3 = YES;
            }
        }
    });
    
    dispatch_async(queue, ^{
        [[NSThread currentThread] setName:@"thread3"];
        while (1) {
            if (thread3) {
                thread3 = NO;
                NSLog(@"----3----%@",[NSThread currentThread]);
                thread1 = YES;
            }
        }
    });
}

/// 监听网络统一返回，并行请求
- (void)test1_1
{
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group1);
    dispatch_group_async(group1, queue1, ^{
        dispatch_group_leave(group1);
        NSLog(@"group1 --- 1---%@",[NSThread currentThread]);
    });
    NSLog(@"============ 分割线1 ==============");
    dispatch_group_enter(group1);
    dispatch_group_async(group1, queue1, ^{
        dispatch_group_leave(group1);
        NSLog(@"group1 --- 2---%@",[NSThread currentThread]);

    });
    NSLog(@"============ 分割线2 ==============");
    dispatch_group_enter(group1);
    dispatch_group_async(group1, queue1, ^{
        dispatch_group_leave(group1);
        NSLog(@"group1 --- 3---%@",[NSThread currentThread]);
    });
    NSLog(@"============ 分割线3 ==============");
    dispatch_group_enter(group1);
    dispatch_group_async(group1, queue1, ^{
        dispatch_group_leave(group1);
        NSLog(@"group1 --- 4---%@",[NSThread currentThread]);
    });
    
    dispatch_group_notify(group1, queue1, ^{
       NSLog(@"group1 --- 结束 ---%@",[NSThread currentThread]);
    });

}

/**
 组内并行，组间串行
 */
- (void)test1 {
    
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 1---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 2---%@",[NSThread currentThread]);

    });
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 3---%@",[NSThread currentThread]);

    });
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 4---%@",[NSThread currentThread]);

    });
    
    dispatch_group_wait(group1,DISPATCH_TIME_FOREVER);
    
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 1---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 2---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 3---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 4---%@",[NSThread currentThread]);
    });
}


- (void)test2 {
    
    NSOperationQueue *oq = [[NSOperationQueue alloc] init];
    oq.maxConcurrentOperationCount = 1;
    [oq addOperationWithBlock:^{
        NSLog(@"1--%@",[NSThread currentThread]);
    }];
    [oq addOperationWithBlock:^{
        NSLog(@"2--%@",[NSThread currentThread]);
    }];
    [oq addOperationWithBlock:^{
        NSLog(@"3--%@",[NSThread currentThread]);
    }];
    [oq addOperationWithBlock:^{
        NSLog(@"4--%@",[NSThread currentThread]);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"----5----%@",[NSThread currentThread]);
        }];
    }];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"6--%@",[NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"7--%@",[NSThread currentThread]);

    }];
    [operation addExecutionBlock:^{
        NSLog(@"8--%@",[NSThread currentThread]);
    }];
    [operation start];
}

/**
 组内串行，组间并行
 */
- (void)test3 {
    
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("leador", DISPATCH_QUEUE_SERIAL);
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 1---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 2---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 3---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group1, queue1, ^{
        NSLog(@"group1 --- 4---%@",[NSThread currentThread]);
    });
    
    dispatch_group_notify(group1, queue1, ^{
        NSLog(@"123");
    });

    dispatch_group_t group2 = dispatch_group_create();
    dispatch_queue_t queue2 = dispatch_queue_create("leador1", DISPATCH_QUEUE_SERIAL);

    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 1---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 2---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 3---%@",[NSThread currentThread]);
    });
    dispatch_group_async(group2, queue2, ^{
        NSLog(@"group2 --- 4---%@",[NSThread currentThread]);
    });
}

/*
 通知，代理，KVO同步执行
 在哪个线程中发出通知或者代理回到就在哪个线程中执行
 */
- (void) test0 {//能收到
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [[NSThread currentThread] setName:@"obseverrName"];
        NSLog(@"1--%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti) name:@"hehe" object:nil];
    });
    
    dispatch_async(queue, ^{
        [[NSThread currentThread] setName:@"postName"];
        NSLog(@"2--%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hehe" object:nil];
        NSLog(@"123");
    });
    
    NSLog(@"456");
}
- (void)noti {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"3--%@",[NSThread currentThread]);
    });
    NSLog(@"4--%@",[NSThread currentThread]);
}


@end
