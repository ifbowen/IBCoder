//
//  IBController23.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/17.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController23.h"

@interface IBController23 ()

@end

@implementation IBController23

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
/*
 Edit scheme -> Run -> Arguments 中
 简略的时间：环境变量 DYLD_PRINT_STATISTICS 设为 1
 详细的时间，环境变量 DYLD_PRINT_STATISTICS_DETAILS 设为 1
 
 启动：冷启动、热启动
 
 简而言之：APP启动主要流程: 点击icon -> 加载动态链接库等 -> 映像文件加载imageLoader ->  runtime -> load  -> main -> delegate.
 
 1、APP启动时间
 1）main之前的系统dylib（动态链接库）和自身App可执行文件的加载的时间
 2）main之后执行didFinishLaunchingWithOptions:结束前的时间
 2、main之前的加载过程
 1）首先加载可执行文件（自身app的所有.o文件集合）
 2）然后加载动态链接库dyld，dyld是一个专门用来加载动态链接库的库
 3）执行从dyld开始，dyld从可执行文件的依赖开始，递归加载所有的依赖动态链接库
 4）动态链接库包括：iOS中用到的所有系统的framework，加载OC runtime方法的libobjec，系统级别的libSystem,例如libdispatch(GCD)he libsystem_blocks(Block)
 5）dyld：the dynamic link editor,所有动态链接库和我们App的静态库.a和所有类文件编译后.o文件，最终都由dyld加载到内存的
 3、动态链接库库是相对于系统来讲的
 4、可执行文件是相对于App本身来讲的
 5、每个app 都是以镜像为单位进行加载的
 1）镜像（Mirroring）是冗余的一种类型，一个磁盘上的数据在另一个磁盘上存在一个完全相同的副本即为镜像。
 2）镜像是一种文件存储形式，可以把许多文件做成一个镜像文件。
 3）每个镜像又都有个ImageLoader类来负责加载，一一对应的关系
 6、framework 是动态链接库和相应资源包含在一起的一个文件结构
 7、系统使用动态链接库的好处
 1）代码共用：很多程序都动态链接了这些lib，但它们在内存和磁盘中只有一份
 2）易于维护：由于被依赖的lib是程序执行时才链接的，所以这些很容易更新，只要保证在程序执行之前，获取最新lib即可
 3）减少可执行文件体积：相比静态链接，动态链接在编译时不需要打进去，所有可执行文件的体积要小很多
 8、动态链接库的加载步骤具体分为5步
 1）load dylibs image 读取库镜像文件
 2）Rebase image 重定位镜像
 3）Bind image 组装镜像
 4）Objc setup 设置对象
 5）initializers 初始化
 9、第一步又分为下面6个过程
 1）分析所依赖的动态库
 2）找到动态库的mach-o 文件(我们知道Windows下的文件都是PE文件，同样在OS X和iOS中可执行文件是Mach-o格式的。)
 3）打开文件
 4）验证文件
 5）在系统核心注册文件签名
 6）对动态库的每一个segment调用mmap()
 10、8.2，8.3
 由于ASLR（address apace layout randomization）的存在，可执行文件和动态链接库在虚拟内存中的加载地址每次启动都不固定，所以需要这两步俩修复镜像中的资源地址，来纸箱正确的地址
 1）rabase 修复的是指当前镜像内存的资源指针；bind指向的是镜像外部的资源指针
 2）rebase步骤先进行，需要把镜像读入内存，并以page为单位进行加密验证，保证不会被篡改；bind 在其后进行，由于要查询表符号表，来指向镜像的资源；
 11、8.4
 1) 注册objc类
 2）把category的定义插入方法列表
 3）保证每个selector唯一
 12、8.5
 0）以上三步属于静态调整（fix up），都是在修改__DATA segment中内容，从这里开始动态调整，开始在堆和堆栈写入内容
 1）objc 的 + load 函数
 2）C++的构造函数属性函数 形如 attribute((contructor))void DoSomeInitializationWork()
 3）非基本类型的C++静态全局变量的创建（通常是类或结构体）（non-trivial initializer）重大初始化
 13、再次回顾整个调用顺序
 1）dyld 开始将程序二进制文件初始化
 2）交由ImageLoader 读取 image，其中包含了我们的类，方法等各种符号（Class、Protocol 、Selector、 IMP）
 3）由于runtime 向dyld 绑定了回调，当image加载到内存后，dyld会通知runtime进行处理
 4）runtime 接手后调用map_images做解析和处理
 5）接下来load_images 中调用call_load_methods方法，遍历所有加载进来的Class，按继承层次依次调用Class的+load和其他Category的+load方法
 6）至此 所有的信息都被加载到内存中
 7）最后dyld调用真正的main函数
 8）注意：dyld会缓存上一次把信息加载内存的缓存，所以第二次比第一次启动快一点
 
 
 pre-main阶段的优化
 要对pre-main阶段的耗时做优化，需要再学习下dyld加载的过程，根据Apple在WWDC上的介绍，dyld的加载主要分为4步：
 
 1. Load dylibs
 这一阶段dyld会分析应用依赖的dylib，找到其mach-o文件，打开和读取这些文件并验证其有效性，接着会找到代码签名注册到内核，最后对dylib的每一
 个segment调用mmap()。一般情况下，iOS应用会加载100-400个dylibs，其中大部分是系统库，这部分dylib的加载系统已经做了优化。
 所以，依赖的dylib越少越好。在这一步，我们可以做的优化有：
 1)尽量不使用内嵌（embedded）的dylib，加载内嵌dylib性能开销较大
 2)合并已有的dylib和使用静态库（static archives），减少dylib的使用个数
 3)懒加载dylib，但是要注意dlopen()可能造成一些问题，且实际上懒加载做的工作会更多
 
 2. Rebase/Bind
    在dylib的加载过程中，系统为了安全考虑，引入了ASLR（Address Space Layout Randomization）技术和代码签名。由于ASLR的存在，镜
 像（Image，包括可执行文件、dylib和bundle）会在随机的地址上加载，和之前指针指向的地址（preferred_address）会有一个偏差（slide）
 ，dyld需要修正这个偏差，来指向正确的地址。
    Rebase在前，Bind在后，Rebase做的是将镜像读入内存，修正镜像内部的指针，性能消耗主要在IO。Bind做的是查询符号表，设置指向镜像外部的
 指针，性能消耗主要在CPU计算。
 所以，指针数量越少越好。在这一步，我们可以做的优化有：
 1)减少ObjC类（class）、方法（selector）、分类（category）的数量
 2)减少C++虚函数的的数量（创建虚函数表有开销）
 3)使用Swift structs（内部做了优化，符号数量更少）
 
 3. Objc setup
    大部分ObjC初始化工作已经在Rebase/Bind阶段做完了，这一步dyld会注册所有声明过的ObjC类，将分类插入到类的方法列表里，再检查每
 个selector的唯一性。
 在这一步倒没什么优化可做的，Rebase/Bind阶段优化好了，这一步的耗时也会减少。
 
 4. Initializers
    到了这一阶段，dyld开始运行程序的初始化函数，调每个Objc类和分类+load方法，调C/C++中的构造器函数（用attribute((constructor))
 修饰的函数），和创建非基本类型的C++静态全局变量。Initializers阶段执行完后，dyld开始调用main()函数。
 在这一步，我们可以做的优化有：
 1)少在类的+load方法里做事情，尽量把这些事情推迟到+initiailize
 2)减少构造器函数个数，在构造器函数里少做些事情
 3)减少C++静态全局变量的个数
 4)main()阶段的优化
    这一阶段的优化主要是减少didFinishLaunchingWithOptions方法里的工作，在didFinishLaunchingWithOptions方法里，我们会创建应用
 的window，指定其rootViewController，调用window的makeKeyAndVisible方法让其可见。由于业务需要，我们会初始化各个二方/三方库，设置
 系统UI风格，检查是否需要显示引导页、是否需要登录、是否有新版本等，由于历史原因，这里的代码容易变得比较庞大，启动耗时难以控制。
 
 所以，满足业务需要的前提下，didFinishLaunchingWithOptions在主线程里做的事情越少越好。在这一步，我们可以做的优化有：
 @1梳理各个二方/三方库，找到可以延迟加载的库，做延迟加载处理，比如放到首页控制器的viewDidAppear方法里。
 @2梳理业务逻辑，把可以延迟执行的逻辑，做延迟执行处理。比如检查新版本、注册推送通知等逻辑。
 @3避免复杂/多余的计算。
 @4避免在首页控制器的viewDidLoad和viewWillAppear做太多事情，部分可以延迟创建的视图应做延迟创建和懒加载处理。
 @5采用性能更好的API。
 @6首页控制器用纯代码方式来构建
 
 */
