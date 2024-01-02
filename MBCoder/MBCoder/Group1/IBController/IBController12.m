//
//  IBController12.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController12.h"

@interface IBController12 ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_source_t gcdtimer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

/*
 Runloops是线程相关底层基础的一部分。它的本质和字面意思一样运行着的循环（事件处理的循环），
 作用：接受循环事件和安排线程的工作。
 目的：让线程在有任务的时候忙于工作，而没任务的时候处于休眠状态。
 使用：Runloop的管理并非完全自动。在主线程中runloop是自动创建并运行（在子线程开启RunLoop需要手动创建且手动开启）。
 
 一、Runloop概念
 1、运行循环，其实内部就是do-while循环
 1）iOS中通常所说的RunLoop指的是NSRunloop(Foundation框架)或者CFRunloopRef(CoreFoundation框架) ，CFRunloopRef是纯C的函数，而 NSRunloop仅仅是CFRunloopRef的一层OC封装，并未提供额外的其他功能，因此要了解RunLoop内部结构，需要多研究CFRunLoopRef API（Core Foundation\更底层）。
 2）CFRunloopRef其实就是 __CFRunloop这个结构体指针（按照OC的思路我们可以将RunLoop看成一个对象），这个对象的运行才是我们通常意义上说的运行循环，核心方法是 __CFRunloopRun()
 
 二、Runloop作用
 1、保持程序的持续运行（如：程序一启动就会开启一个主线程（主线程中的runloop是自动创建并运行），runloop保证主线程不会被销毁，也就保证了程序的持续运行）。
 2、处理App中的各种事件（如：touches 触摸事件、NSTimer 定时器事件、Selector事件（选择器performSelector））。
 3、节省CPU资源，提高程序性能（有事情就做事情，没事情就休息 (其资源释放)）。
 4、负责渲染屏幕上的所有UI。
 
 三、Runloop和线程关系
 1.每条线程都有唯一的一个与之对应的RunLoop对象。
 2.主线程的RunLoop已经自动创建，子线程的RunLoop需要主动创建。
 3.RunLoop在第一次获取时创建，在线程结束时销毁。
 4.如何创建子线程对应的 Runloop
 【解决】：开一个子线程创建 runloop ，不是通过[alloc init]方法创建，而是直接通过调用currentRunLoop 方法来创建。
 【原因】：currentRunLoop本身是懒加载的，当第一次调用currentRunLoop方法获得该子线程对应的Runloop的时候,它会先去判断(去字典中查找)这个线程的Runloop是否存在,如果不存在就会自己创建并且返回,如果存在直接返回。
 
 四、Runloop相关类
 1、CFRunloopRef【RunLoop本身】
 2、CFRunloopModeRef【Runloop的运行模式】
 3、CFRunloopSourceRef【Runloop要处理的事件源】
 4、CFRunloopTimerRef【Timer事件】
 5、CFRunloopObserverRef【Runloop的观察者（监听者）】
 
 1）一条线程对应一个Runloop，Runloop总是运行在某种特定的CFRunLoopModeRef（运行模式）下。
 2）每个Runloop都可以包含若干个Mode ，每个Mode又包含Source源/Timer事件/Observer观察者。
 3）在Runloop中有多个运行模式，每次调用 RunLoop 的主函数【__CFRunloopRun()】时，只能指定其中一个Mode（称CurrentMode）运行，如果需要切换Mode，只能是退出CurrentMode切换到指定的Mode进入，目的以保证不同Mode下的Source/Timer/Observer互不影响。
 4）Runloop有效，mode里面至少要有一个timer(定时器事件)或者是source(源)；
 
 五、Runloop 相关类（Mode）
 CFRunLoopModeRef 代表 RunLoop 的运行模式；系统默认提供了5个 Mode 。
 
 1.【kCFRunLoopDefaultMode (NSDefaultRunLoopMode)】: App的默认Mode，通常主线程是在这个Mode下运行。
 2.【UITrackingRunLoopMode】: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
 3.【UIInitializationRunLoopMode】: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
 4.【GSEventReceiveRunLoopMode】: 接受系统事件的内部 Mode，通常用不到。
 5.【kCFRunLoopCommonModes (NSRunLoopCommonModes)】: 这个并不是某种具体的 Mode, 可以说是一个占位用的Mode（一种模式组合）。

 1）【关于_commonModes】：一个mode可以标记为common属性（用于CFRunLoopAddCommonMode函数），然后它就会保存在_commonModes。主线程CommonModes默认已有两个mode kCFRunLoopDefaultMode和UITrackingRunLoopMode，当然你也可以通过调用 CFRunLoopAddCommonMode()方法将自定义mode放到kCFRunLoopCommonModes组合）。
 2）【关于_commonModeItems】：_commonModeItems里面存放的source, observer, timer等，在每次runLoop运行的时候都会被同步到具有 Common标记的Modes里。如：[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; 就是把timer放到commonModeItems里。
 
 六、CFRunloopSourceRef 事件源\输入源，有两种分类模式
 按照函数调用栈的分类source0和source1
 Source0：非基于端口Port的事件；（手动触发的事件，如：点击按钮或点击屏幕）。
 Source1：基于端口Port的事件；（系统自动触发的事件，如：处理系统信号、处理端口相关事件（网络）、处理其他线程的事件）。
 补充：Source1事件在处理时会分发一些操作给Source0去处理。
 
 七、Runloop相关类（Timer）
 1、CFRunLoopTimerRef是基于时间的触发器。
 2、基本上说的就是NSTimer(CADisplayLink也是加到RunLoop),它受RunLoop的Mode影响。
 3、而与NSTimer相比，GCD定时器不会受Runloop影响。
 
 八、Runloop相关类（Observer）
 相对来说CFRunloopObserverRef理解起来并不复杂，它相当于消息循环中的一个监听器，随时通知外部当前RunLoop的运行状态（它包含一个函数指针_callout_将当前状态及时告诉观察者）。具体的Observer状态如下：
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
 kCFRunLoopEntry = (1UL << 0),           //即将进入Runloop
 kCFRunLoopBeforeTimers = (1UL << 1),    //即将处理NSTimer
 kCFRunLoopBeforeSources = (1UL << 2),   //即将处理Sources
 kCFRunLoopBeforeWaiting = (1UL << 5),   //即将进入休眠
 kCFRunLoopAfterWaiting = (1UL << 6),    //从休眠装填中唤醒
 kCFRunLoopExit = (1UL << 7),            //退出runloop
 kCFRunLoopAllActivities = 0x0FFFFFFFU   //所有状态改变
 };
 
 九、RunLoop与 Autorelease Pool 有关系么？
 
 我们总是看到有文章说程序启动后，苹果在主线程 RunLoop 里注册了两个 Observer：
 第一个 Observer 监视的事件是 Entry(即将进入Loop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
 第二个 Observer 监视了两个事件： BeforeWaiting(准备进入睡眠) 和 Exit(即将退出Loop)，
 BeforeWaiting(准备进入睡眠)时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；
 Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。
 
 打印出MainRunLoop，可以看到MainRunLoop的 Common mode Items 中就有这两个观察者
 
 十、Runloop应用\场景
 1、NSTimer
 2、ImageView延迟加载显示：控制方法在特定的模式下可用
 3、PerformSelector
 4、常驻线程：在子线程中开启一个runloop
 5、AutoreleasePool自动释放池
 6、UI更新
 
 十二、基于RunLoop的事件处理流程
      按键（HOME键、锁屏键、音量键等）、传感器（摇晃、加速等）、触摸屏幕等【物理事件】会触发IOKit.framework生成
 一个IOHIDEvent对象，然后SpringBoard会接收这个对象并通过mach port发给当前App的进程；接下来进程会触发RunLoop
 的基于port的Source1回调一个__IOHIDEventSystemClientQueueCallback()的API，这个API会相应触发Source0来调
 用__UIApplicationHandleEventQueue()，而此API再将传递到此的IOHIDEvent处理包装成上层所熟悉的UIEvent。最后
 UIEvent会被分发给UIWindow根据Respond chain来响应事件。
 
      整个事件处理流程是基于RunLoop的基本处理循环进行的。在main函数开始后，主线程的runloop对象被创建完。
 如UIEvent、UI绘制等会统一在主线程的runloop对象的即将进入休眠前的时间点触发各自对应的代理回调方法，然后
 runloop进入休眠，直到被timer定时器或Source1发来的内核消息事件唤醒，再分别对Timer、Source0、Source1
 发来的事件进行处理回调。
 
 十三、RunLoop的运行逻辑（打断点，bt调试查看详细信息）
 01、通知Observers：进入Loop
 02、通知Observers：即将处理Timers
 03、通知Observers：即将处理Sources
 04、处理Blocks
 05、处理Source0（可能会再次处理Blocks）
 06、如果存在Source1，就跳转到第8步
 07、通知Observers：开始休眠（等待消息唤醒）
 08、通知Observers：结束休眠（被某个消息唤醒）
    01> 处理Timer
    02> 处理GCD （GCD有自己的处理逻辑，只有Async To Main Queue这一个情况是runloop处理）
    03> 处理Source1
 09、处理Blocks
 10、根据前面的执行结果，决定如何操作
    01> 回到第02步
    02> 退出Loop
 11、通知Observers：退出Loop
 
 十四、PerformSelecter
 当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。
 所以如果当前线程没有 RunLoop，则这个方法会失效。

 当调用 performSelector:onThread: 时，实际上其会创建一个 source1 加到对应的线程去，
 同样的，如果对应线程没有 RunLoop 该方法也会失效。
 


 */


@implementation IBController12

- (NSThread *)thread {
    static NSThread *_thread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(work) object:nil];
        [_thread setName:@"bowen"];
        [_thread start];
    });
    return _thread;
}
- (void)work {
    NSLog(@"%s", __func__);
    
    @autoreleasepool {
        //添加Port 实时监听
        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        //添加runloop
        [[NSRunLoop currentRunLoop] run];
    }
    
    //实现方法二
//    @autoreleasepool {
//        while (1) {
//            //添加runloop
//            [[NSRunLoop currentRunLoop]run];
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerObserver];
}

- (void)registerObserver
{
    // 创建Observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"kCFRunLoopEntry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"kCFRunLoopBeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"kCFRunLoopBeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"kCFRunLoopBeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"kCFRunLoopAfterWaiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopExit");
                break;
            default:
                break;
        }
    });
    // 添加Observer到RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    // 释放
    CFRelease(observer);
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
//    [self test2];
    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
}



- (void)test6 {
    [self performSelector:@selector(runTest) onThread:[self thread] withObject:nil waitUntilDone:NO];
}

- (void)runTest {
    NSLog(@"%s",__func__);
}

/**
 CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。 CADisplayLink以特定模式注册到runloop后， 每当屏幕显示内容刷新结束的时候，runloop就会向 CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。
 
 iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。使用场合相对专一，适合做UI的不停重绘，比如自定义动画引擎或者视频播放的渲染。不需要在格外关心屏幕的刷新频率了，本身就是跟屏幕刷新同步的。
 */
- (void)test5 {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(run)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
}
- (void)stopDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
}


/*
 GCD定时器不受RunLoop影响，所以是绝对精准的。
 */
- (void)test4 {
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    /**
     *  第一个参数: DISPATCH_SOURCE_TYPE_TIMER,source的类型，表示的是定时器
     *  第二个参数: 描述信息，线程ID;
     *  第三个参数: 更详细的描述信息;
     *  第四个参数: 队列，决定在哪个线程中运行
     */
    self.gcdtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    /**
     *  第一个参数: dispatch_source_t, Dispatch Source
     *  第二个参数: 开始时刻;
     *  第三个参数: 间隔<例子中是一秒>;
     *  第四个参数: 精度<最高精度将之设置为0>
     */
    //NSEC_PER_SEC表示的是秒数，它还提供了NSEC_PER_MSEC表示毫秒。
    dispatch_source_set_timer(self.gcdtimer, DISPATCH_TIME_NOW, NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.gcdtimer, ^{
        NSLog(@"%@",[NSThread currentThread]);
//        dispatch_source_cancel(self.gcdtimer);
//        dispatch_suspend(self.gcdtimer);//不能在此block中使用
    });
    dispatch_resume(self.gcdtimer);
    
    
}

- (void)test3 {
    /*
     scrollview处于滚动状态时，timer停止工作
     滚动时，runloop运行模式会自动切换到UITrackingRunLoopMode界面追踪模式，而timer处于NSDefaultRunLoopMode模式。所以不工作
     停止时，又切换到NSDefaultRunLoopMode默认模式，timer继续工作
     */
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)test2 {
    //子线程中直接调用timer没有效果，因为子线程中runloop需要主动开启
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%s",__func__);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });
}

/*
 NSTimer 其实就是 CFRunLoopTimerRef，他们之间是 toll-free bridged 的。一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00, 10:10, 10:20 这几个时间点。RunLoop为了节省资源，并不会在非常准确的时间点回调这个Timer。Timer 有个属性叫做 Tolerance (宽容度)，标示了当时间点到后，容许有多少最大误差。
 存在延迟：不管是一次性的还是周期性的timer的实际触发事件的时间，都会与所加入的RunLoop和RunLoop Mode有关，如果此RunLoop正在执行一个连续性的运算，timer就会被延时出发。
 */
//主线程中
- (void)test1 {
    //主线程中该方法内部自动添加到runloop中，并设置运行模式为默认模式
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    //修改运行模式
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)run {
    NSLog(@"run");
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end


/**
 /// 用DefaultMode启动
 void CFRunLoopRun(void) {
     CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
 }
  
 /// 用指定的Mode启动，允许设置RunLoop超时时间
 int CFRunLoopRunInMode(CFStringRef modeName, CFTimeInterval seconds, Boolean stopAfterHandle) {
     return CFRunLoopRunSpecific(CFRunLoopGetCurrent(), modeName, seconds, returnAfterSourceHandled);
 }
  
 /// RunLoop的实现
 int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {
     
     /// 首先根据modeName找到对应mode
     CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
     /// 如果mode里没有source/timer/observer, 直接返回。
     if (__CFRunLoopModeIsEmpty(currentMode)) return;
     
     /// 1. 通知 Observers: RunLoop 即将进入 loop。
     __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
     
     /// 内部函数，进入loop
     __CFRunLoopRun(runloop, currentMode, seconds, returnAfterSourceHandled) {
         
         Boolean sourceHandledThisLoop = NO;
         int retVal = 0;
         do {
  
             /// 2. 通知 Observers: RunLoop 即将触发 Timer 回调。
             __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
             /// 3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
             __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
             /// 执行被加入的block
             __CFRunLoopDoBlocks(runloop, currentMode);
             
             /// 4. RunLoop 触发 Source0 (非port) 回调。
             sourceHandledThisLoop = __CFRunLoopDoSources0(runloop, currentMode, stopAfterHandle);
             /// 执行被加入的block
             __CFRunLoopDoBlocks(runloop, currentMode);
  
             /// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
             if (__Source0DidDispatchPortLastTime) {
                 Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
                 if (hasMsg) goto handle_msg;
             }
             
             /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
             if (!sourceHandledThisLoop) {
                 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
             }
             
             /// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
             /// 1）一个基于 port 的Source 的事件。
             /// 2）一个 Timer 到时间了
             /// 3）RunLoop 自身的超时时间到了
             /// 4）被其他什么调用者手动唤醒
             __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
                 mach_msg(msg, MACH_RCV_MSG, port); // thread wait for receive msg
             }
  
             /// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
             __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
             
             /// 收到消息，处理消息。
             handle_msg:
  
             /// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
             if (msg_is_timer) {
                 __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
             }
  
             /// 9.2 如果有dispatch到main_queue的block，执行block。
             else if (msg_is_dispatch) {
                 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
             }
  
             /// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
             else {
                 CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
                 sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
                 if (sourceHandledThisLoop) {
                     mach_msg(reply, MACH_SEND_MSG, reply);
                 }
             }
             
             /// 执行加入到Loop的block
             __CFRunLoopDoBlocks(runloop, currentMode);
             
  
             if (sourceHandledThisLoop && stopAfterHandle) {
                 /// 进入loop时参数说处理完事件就返回。
                 retVal = kCFRunLoopRunHandledSource;
             } else if (timeout) {
                 /// 超出传入参数标记的超时时间了
                 retVal = kCFRunLoopRunTimedOut;
             } else if (__CFRunLoopIsStopped(runloop)) {
                 /// 被外部调用者强制停止了
                 retVal = kCFRunLoopRunStopped;
             } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
                 /// source/timer/observer一个都没有了
                 retVal = kCFRunLoopRunFinished;
             }
             
             /// 如果没超时，mode里没空，loop也没被停止，那继续loop。
         } while (retVal == 0);
     }
     
     /// 10. 通知 Observers: RunLoop 即将退出。
     __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
 
 */







