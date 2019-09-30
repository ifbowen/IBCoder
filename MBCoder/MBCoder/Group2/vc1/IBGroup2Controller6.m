//
//  IBGroup2Controller6.m
//  IBCoder1
//
//  Created by Bowen on 2019/8/28.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2Controller6.h"
#import <execinfo.h>

@interface IBGroup2Controller6 ()

@end

@implementation IBGroup2Controller6

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    registerSignalHandler();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test)];
}

// 方法一

void registerSignalHandler(void){
    signal(SIGSEGV, handleSignalException);//试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.
    signal(SIGFPE, handleSignalException);//在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误。
    signal(SIGBUS, handleSignalException);//非法地址, 包括内存地址对齐(alignment)出错。比如访问一个四个字长的整数, 但其地址不是4的倍数。它与SIGSEGV的区别在于后者是由于对合法存储地址的非法访问触发的(如访问不属于自己存储空间或只读存储空间)。
    signal(SIGPIPE, handleSignalException);//管道破裂。这个信号通常在进程间通信产生，比如采用FIFO管道通信的两个进程，读管道没打开或者意外终止就往管道写，写进程会收到SIGPIPE信号。此外用Socket通信的两个进程，写进程在写Socket的时候，读进程已经终止
    signal(SIGHUP, handleSignalException);//本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业,这时它们与控制终端不再关联。登录Linux时，系统会分配给登录用户一个终端(Session)。在这个终端运行的所有程序，包括前台进程组和后台进程组，一般都属于这个 Session。当用户退出Linux登录时，前台进程组和后台有对终端输出的进程将会收到SIGHUP信号。这个信号的默认操作为终止进程，因此前台进 程组和后台有终端输出的进程就会中止。不过可以捕获这个信号，比如wget能捕获SIGHUP信号，并忽略它，这样就算退出了Linux登录， wget也 能继续下载。此外，对于与终端脱离关系的守护进程，这个信号用于通知它重新读取配置文件。
    signal(SIGINT, handleSignalException);//程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进  程组终止进程。
    signal(SIGQUIT, handleSignalException);//和SIGINT类似, 但由QUIT字符(通常是Ctrl-)来控制. 进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号。
    signal(SIGABRT, handleSignalException);//调用abort函数生成的信号。
    signal(SIGILL, handleSignalException);//执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号。
}
void handleSignalException(int signal){
    void *callStack[128];
    int frames = backtrace(callStack,128);
    char **traceChar = backtrace_symbols(callStack,frames);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; ++i) {
        NSString *symbol = [NSString stringWithUTF8String:traceChar[i]];
        [backtrace addObject:symbol];
    }
    NSLog(@"%@", backtrace);
}

// 方法二（性能消耗小，获取简单的信息）

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *exceptionArray = [exception callStackSymbols]; // 得到当前调用栈信息
    NSString *exceptionReason = [exception reason];       // 非常重要，就是崩溃的原因
    NSString *exceptionName = [exception name];           // 异常类型
}

void SignalHandler(int code)
{
    NSLog(@"signal handler = %d",code);
}

void InitCrashReport()
{
    // 系统错误信号捕获
    for (int i = 0; i < s_fatal_signal_num; ++i) {
        signal(s_fatal_signals[i], SignalHandler);
    }
    
    //oc 未捕获异常的捕获
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}


/*
 1、常见可捕捉的崩溃信号
 1）数组越界：在取数据索引时越界，App 会发生崩溃。还有一种情况，就是给数组添加了 nil 会崩溃。
 2）多线程问题：在子线程中进行 UI 更新可能会发生崩溃。多个线程进行数据的读取操作，因为处理时机不一致，
           比如有一个线程在置空数据的同时另一个线程在读取这个数据，可能会出现崩溃
 3）主线程无响应：如果主线程超过系统规定的时间无响应，就会被 Watchdog 杀掉。这时，崩溃问题对应的异常编码是 0x8badf00d。
 4）野指针：指针指向一个已删除的对象访问内存区域时，会出现野指针崩溃。野指针问题是需要我们重点关注的，
        因为它是导致 App 崩溃的最常见，也是最难定位的一种情况。
 5）其他：KVO问题，NSNotification 线程问题
 
 2、不可捕捉的崩溃信号，像后台任务超时、内存被打爆、主线程卡顿超阈值
 App退到后台后,即使代码逻辑没有问题也容易出现崩溃,而且这些崩溃往往是因为系统强杀掉了某些进程导致的,
 而系统强杀抛出的信号还由于系统限制无法被捕捉到.
 
 1)后台容易崩溃的原因是什么?
 iOS后台保活的5种方式:Background Mode,Background Fetch,Silent Push,PushKit,Background Task
 1.使用Background Mode方式的话,AppStore在审核时会提高对App的要求,通常情况下,只有那些地图,音乐播放,VoIP类的App才能通过审核
 2.Background Fetch 方式的唤醒时间不稳定,而且用户可以在系统设置关闭这种方式,导致他的使用场景很少
 3.Silent Push是推送的一种,会在后台唤起App 30秒.会调起application:didReceiveRemoteNotifiacation这个delegate
   和普通的remote pushnotification推送调用的delegate是一样的
 4.PushKit后台唤醒App后能够包活30秒,他主要用于提升VoIp应用的体验
 5.Background Task方式,是使用最多的,App退到后台后,默认都会使用这种方式
 
 使用最多的Background Task方式:
 在程序退到后台后,只有几秒钟的时间可以执行代码,接下来会被系统挂起,进程挂起后所有的线程都会暂停,
 不管这个线程是文件读写还是内存读写都会被暂停,但是,数据读写过程无法暂停只能被中断,中断时数据读写异常而且容易损坏文件,
 所以系统会选择主动杀掉进程.
 
 延长后台执行时间至3分钟，在三分钟内没有执行完的话,就会被系统强行杀掉进程,造成崩溃.
 - (void)applicationDidEnterBackground:(UIApplication *)application {
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [self youTask];
    }];
 }
 
 怎么去收集后台信号捕捉不到的那些崩溃信息呢?
 采用Background Task方式时,我们可以根据beginBackgroundTaskWithExpirationHandler会让后台保活三分钟,
 先设置一个定时器,在接近三分钟的时候判断后台程序是否还在执行,如果还在执行的话,我们就可以判断该程序即将后台崩溃,
 进行上报记录,已达到监控的效果
 
 还有那些信号捕捉不到的崩溃情况?怎么去监控其他无法通过信号捕捉的崩溃信息?
 其他捕捉不到的崩溃情况还有很多,主要就是内存打爆和主线程卡顿时间超过阈值被watchdog杀掉,
 其实监控这两种崩溃的思路和监控后台崩溃类似,我们要先找到他们的阈值,然后在临近阈值时还在执行的后台程序,
 判断为将要崩溃,收集信息并上报

 */

@end
